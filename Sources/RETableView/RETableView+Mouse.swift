// ----------------------------------------------------------------------------
//
//  RETableView+Mouse.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import AppKit

extension RETableView {

    private struct Inner {
        static var updatedSelectedRows: Set<Int> = Set<Int>()
        static var isEntityMoved: Bool = false
        static var multiplyEntitiesAdded: Bool = false
        static var singleEntityAdded: Bool = false

        static func reset() {
            updatedSelectedRows = Set<Int>()
            isEntityMoved = false
            multiplyEntitiesAdded = false
            singleEntityAdded = false
        }
    }

    public override func mouseDown(with event: NSEvent) {
        guard var selectedIndex = getSelectedIndex(from: event) else {
            return
        }
        Inner.reset()
        if event.clickCount == 2 {
            delegate?.itemDidPressed(at: selectedIndex)
            return
        }
        checkModifier(event.modifierFlags, for: selectedIndex)

        while true {
            guard let newEvent = self.window?.nextEvent(matching: [.leftMouseDragged, .leftMouseUp]) else {
                break
            }

            if newEvent.type == .leftMouseUp {
                handleLeftMouseUp(with: selectedIndex)
                updateSelection()
                break
            }

            if newEvent.type == .leftMouseDragged {
                delegate?.didBeginMovingItems()
                handleLeftMouseDragged(newEvent, with: &selectedIndex)
                continue
            }
            Inner.isEntityMoved = false
        }
    }

    public override func rightMouseUp(with event: NSEvent) {
        guard let contextMenu = contextMenu else { return }
        NSMenu.popUpContextMenu(contextMenu,
                                with: event,
                                for: self)
    }

    public override func rightMouseDown(with event: NSEvent) {
        guard let selectedIndex = getSelectedIndex(from: event),
              selectSingle(index: selectedIndex) else {
            return
        }
        updateSelection()
    }

    private func getSelectedIndex(from event: NSEvent) -> Int? {
        let selectedIndex = offset + itemIndex(for: event)
        guard rowsCount > 0,
              selectedIndex < rowsCount else {
            return nil
        }
        return selectedIndex
    }

    private func itemIndex(for event: NSEvent) -> Int {
        let mousePosition = convert(event.locationInWindow, from: nil)
        let index = Int(mousePosition.y / theme.font.height)
        return index
    }

    private func checkModifier(_ flags: NSEvent.ModifierFlags, for selectedIndex: Int) {
        if flags.contains(.command) {
            if selectedRows.contains(selectedIndex) {
                selectedRows.remove(selectedIndex)
            } else {
                selectedRows.insert(selectedIndex)
            }
            lastSelectedIndex = selectedIndex
            Inner.multiplyEntitiesAdded = true
            Inner.singleEntityAdded = false
        } else if flags.contains(.shift) {
            guard let lastSelectedIndex = lastSelectedIndex,
                  lastSelectedIndex != selectedIndex else {
                return
            }
            selectedRows.removeAll()
            let sortDirection = lastSelectedIndex < selectedIndex ? 1 : -1
            for index in stride(from: lastSelectedIndex, through: selectedIndex, by: sortDirection) {
                selectedRows.insert(index)
            }
            Inner.multiplyEntitiesAdded = true
            Inner.singleEntityAdded = false
        } else if selectSingle(index: selectedIndex) {
            lastSelectedIndex = selectedIndex
            Inner.singleEntityAdded = true
            Inner.multiplyEntitiesAdded = false
        }
    }

    private func handleLeftMouseUp(with selectedIndex: Int) {
        //single selection when multiple entities selected
        if !Inner.isEntityMoved,
           !Inner.multiplyEntitiesAdded,
           !Inner.singleEntityAdded,
            selectedRows.contains(selectedIndex) {
            selectedRows.removeAll()
            setLastSelectedIndex(selectedIndex)
        }

        if Inner.isEntityMoved {
            delegate?.didEndMovingItems()
        }
    }

    private func handleLeftMouseDragged(_ event: NSEvent, with selectedIndex: inout Int) {
        guard let selectionFirstIndex = selectedRows.min(),
              let selectionLastIndex = selectedRows.max() else {
            return
        }
        Inner.isEntityMoved = true
        let currentPosition = itemIndex(for: event)
        let currentPositionWithOffset = currentPosition + offset

        let currentBottom = selectionLastIndex - offset

        if currentPositionWithOffset != selectedIndex {
            // Если сдвигаемые элементы упираются в верхнюю точку плейлиста-скроллим вверх
            if selectionFirstIndex <= 0 &&
                offset == 0 &&
                currentPositionWithOffset <= selectedIndex &&
                currentPositionWithOffset <= 0 {
                return
            }

            if selectionFirstIndex + currentPosition < offset {
                scrollUp()
            }

            // Если сдвигаемые элементы упираются в край плейлиста-скроллим вниз
            if selectionLastIndex >= rowsCount - 1 && currentPositionWithOffset >= selectedIndex {
                return
            }

            if visibleCount - 1 < currentBottom {
                scrollDown()
            }

            if selectedIndex == currentPositionWithOffset {
                return
            }

            // Двигаем элементы
            let diff = currentPositionWithOffset - selectedIndex
            if selectionFirstIndex + diff < 0 ||
                selectionLastIndex + diff > rowsCount - 1 {
                return
            }
            delegate?.didMoveItems(difference: diff, movingIndexes: selectedRows)
            // Обновляем выделенные позиции
            Inner.updatedSelectedRows.removeAll()
            for index in selectedRows {
                let newIndex = index + diff
                Inner.updatedSelectedRows.insert(newIndex)
            }

            selectedRows = Inner.updatedSelectedRows
            selectedIndex = currentPositionWithOffset

            // Обновляем таблицу после всех перемещений
            reloadData()
        }
    }

    internal func updateSelection() {
        delegate?.didSelect(rows: selectedRows)
        needsDisplay = true
    }

    internal func selectSingle(index: Int) -> Bool {
        if !selectedRows.contains(index) {
            selectedRows.removeAll()
            selectedRows.insert(index)
            return true
        }
        return false
    }

}
