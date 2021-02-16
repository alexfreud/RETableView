// ----------------------------------------------------------------------------
//
//  RETableViewTheme.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Cocoa

public struct RETableViewTheme {
    public init(font: NSFont = .systemFont(ofSize: 12),
                  backgroundColor: NSColor = .darkGray,
                  textColor: NSColor = .green,
                  textActiveColor: NSColor = .white,
                  selectionColor: NSColor = .blue) {
        self.font = font
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textActiveColor = textActiveColor
        self.selectionColor = selectionColor
    }

    public var font: NSFont = .systemFont(ofSize: 12)
    public var backgroundColor: NSColor = .darkGray
    public var textColor: NSColor = .green
    public var textActiveColor: NSColor = .white
    public var selectionColor: NSColor = .blue
}
