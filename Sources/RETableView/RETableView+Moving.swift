// ----------------------------------------------------------------------------
//
//  RETableView+Moving.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Foundation

internal extension RETableView {
    func move(to position: Int, needUpdateSlider: Bool = true) {
        if position < 0 || position > maxOffset {
            return
        }
        offset = position
        needsDisplay = true
        if needUpdateSlider {
            setSliderValue()
        }
    }

    func scrollUp() {
        move(to: offset - 1)
    }

    func scrollDown() {
        move(to: offset + 1)
    }
}
