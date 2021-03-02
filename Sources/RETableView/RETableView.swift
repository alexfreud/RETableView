// ----------------------------------------------------------------------------
//
//  RETableView.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Cocoa

final public class RETableView: NSView {

    // MARK: - Public variables

    public weak var delegate: RETableViewDelegate?

    public var contextMenu: NSMenu?

    public weak var slider: NSSlider? {
        didSet {
            slider?.target = self
            slider?.action = #selector(sliderMoved(sender:))
            slider?.maxValue = Double(maxOffset)
        }
    }

    public var theme: RETableViewTheme = RETableViewTheme() {
        didSet {
            needsDisplay = true
        }
    }

    public var selectedRows: Set<Int> = Set<Int>()

    // MARK: - Internal variables

    internal var offset = 0

    internal var lastSelectedIndex: Int?

    internal var visibleCount: Int {
        return Int(floor(frame.size.height / theme.font.height))
    }

    internal var maxOffset: Int {
        return rowsCount - visibleCount
    }

    internal var rowsCount: Int {
        return delegate?.numberOfRows ?? 0
    }

    // MARK: - Public functions

    public func reloadData() {
        if offset > maxOffset {
            offset = maxOffset
        }
        if offset < 0 {
            offset = 0
        }
        slider?.maxValue = Double(maxOffset)
        setSliderValue()
        needsDisplay = true
    }

    public func clearSelection() {
        selectedRows.removeAll()
        lastSelectedIndex = nil
        reloadData()
    }

    public func selectAll() {
        selectedRows = getAllItemsIndexes()
        reloadData()
    }

    public func invertSelection() {
        selectedRows = getAllItemsIndexes().filter({ !selectedRows.contains($0) })
        reloadData()
    }

    public func reset() {
        offset = 0
        clearSelection()
    }

    // MARK: - Private functions

    private func getAllItemsIndexes() -> Set<Int> {
        guard let delegate = delegate else { return Set<Int>() }
        return Set(0..<delegate.numberOfRows)
    }

    private func isVisible(_ position: Int) -> Bool {
        return visibleRange.contains(position)
    }

    private func rect(for position: Int) -> NSRect {
        let yPosition = (CGFloat(position - offset) * theme.font.height)
        return NSRect(x: 0, y: yPosition, width: frame.size.width, height: theme.font.height)
    }

    private var visibleRange: Range<Int> {
        return offset..<offset + visibleCount
    }

    private func drawText(at position: Int) {
        guard isVisible(position), let data = delegate?.getItem(at: position) else {
            return
        }
        let drawRect = rect(for: position)
        if selectedRows.contains(position) {
            theme.selectionColor.setFill()
            drawRect.fill()
        }
        let textColor = data.isActive ? theme.textActiveColor : theme.textColor
        let textAttributes: [NSAttributedString.Key: Any] = [.font: theme.font,
                                                             .foregroundColor: textColor,
                                                             .strikethroughStyle: NSNumber(value: 0)]
        let subTitle = data.subTitle ?? ""

        let subtitleSize = subTitle.isEmpty ?
            NSSize.zero :
            subTitle.size(withAttributes: [.font: theme.font])
        let durationRect = NSRect(x: frame.size.width - subtitleSize.width,
                                  y: drawRect.origin.y,
                                  width: subtitleSize.width,
                                  height: theme.font.height)
        subTitle.draw(with: durationRect,
                      options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
                      attributes: textAttributes,
                      context: nil)
        let title = (theme.showNumbers ? "\(position + 1). " : "") + data.title
        let textRect = NSRect(x: 0,
                              y: drawRect.origin.y,
                              width: frame.size.width - subtitleSize.width,
                              height: theme.font.height)
        title.draw(with: textRect,
                       options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
                       attributes: textAttributes,
                       context: nil)
    }

    // MARK: - Slider handler

    @objc private func sliderMoved(sender: NSSlider) {
        move(to: sender.invertedValue, needUpdateSlider: false)
    }

    internal func setSliderValue() {
        slider?.isHidden = rowsCount == 0 || rowsCount < visibleCount
        slider?.setValue(offset)
    }

    // MARK: - Overriding

    public override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        context.setShouldAntialias(theme.antialiasing)
        theme.backgroundColor.setFill()
        dirtyRect.fill()

        for index in visibleRange {
            if index == rowsCount { break }
            drawText(at: index)
        }
    }

    public override var acceptsFirstResponder: Bool {
        return true
    }

    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }

    public override var isFlipped: Bool {
        return true
    }

    public override func scrollWheel(with event: NSEvent) {
        if event.deltaY > 0 {
            scrollUp()
        }
        if event.deltaY < 0 {
            scrollDown()
        }
    }

}
