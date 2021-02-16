// ----------------------------------------------------------------------------
//
//  RETableView+Keyboard.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Cocoa

extension RETableView {
    public override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0:
            handleSelectionKeys(event.modifierFlags)
        case 36, 76:
            selectPosition()
        case 51, 117:
            handleDeleteKays()
        case 115:
            move(to: 0)
        case 116:
            let beginPageIndex = offset - visibleCount < 0 ? 0 : offset - visibleCount
            move(to: beginPageIndex)
        case 119:
            let lastPage = rowsCount - visibleCount
            move(to: lastPage)
        case 121:
            let endPageIndex = rowsCount - (offset + visibleCount) < visibleCount ?
                rowsCount - visibleCount :
                offset + visibleCount
            move(to: endPageIndex)
        case 125:
            movePositionDown()
        case 126:
            movePositionUp()
        default:
            super.keyDown(with: event)
        }
    }

    private func handleSelectionKeys(_ flags: NSEvent.ModifierFlags) {
        if flags.intersection(.deviceIndependentFlagsMask).contains(.command) {
            if flags.intersection(.deviceIndependentFlagsMask).contains(.option) {
                clearSelection()
            } else {
                selectAll()
            }
        }
    }

    private func handleDeleteKays() {
        if lastSelectedIndex != nil || selectedRows.isEmpty {
            return
        }
        delegate?.didRemove(indexSet: selectedRows)
    }

    private func selectPosition() {
        guard let lastPosition = lastSelectedIndex else {
            return
        }
        clearSelection()
        setLastSelectedIndex(lastPosition)
        delegate?.itemDidPressed(at: lastPosition)
    }

    private func movePosition(handler: () -> Void) {
        defer { reloadData() }
        selectedRows.removeAll()
        guard let lastSelectedIndex = lastSelectedIndex,
              isPositionOutsideVisibleTable(lastSelectedIndex) else {
            handler()
            return
        }
        setLastSelectedIndex(offset)
    }

    private func movePositionUp() {
        if lastSelectedIndex == nil {
            lastSelectedIndex = offset + 1
        }
        movePosition {
            let selectedRow = (lastSelectedIndex ?? 0) - 1 < 0 ? 0 : (lastSelectedIndex ?? 0) - 1
            setLastSelectedIndex(selectedRow)
            if self.lastSelectedIndex == offset - 1 {
                offset -= 1
            }
        }
    }

    private func movePositionDown() {
        if lastSelectedIndex == nil {
            lastSelectedIndex = offset - 1
        }
        movePosition {
            let numberOfRow = rowsCount - 1
            let selectedRow = (lastSelectedIndex ?? 0) + 1 > numberOfRow ? numberOfRow : (lastSelectedIndex ?? 0) + 1
            setLastSelectedIndex(selectedRow)
            if self.lastSelectedIndex == offset + visibleCount {
                offset += 1
            }
        }
    }

    internal func setLastSelectedIndex(_ index: Int) {
        selectedRows.insert(index)
        lastSelectedIndex = index
    }

    private func isPositionOutsideVisibleTable(_ position: Int) -> Bool {
        return position < offset || position > offset + visibleCount
    }

}
