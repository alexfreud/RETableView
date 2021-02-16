// ----------------------------------------------------------------------------
//
//  RETableViewItem.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Foundation

public struct RETableViewItem {
    public var title: String
    public var subTitle: String?
    public var isActive: Bool

    public init(title: String,
                subTitle: String? = nil,
                isActive: Bool = false) {
        self.title = title
        self.subTitle = subTitle
        self.isActive = isActive
    }
}
