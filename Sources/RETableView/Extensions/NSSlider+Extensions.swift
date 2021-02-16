//
//  NSSlider+Extensions.swift
//  TableView
//
//  Created by Александр Васильченко on 18.12.2020.
//

import Cocoa

internal extension NSSlider {
    var invertedValue: Int {
        return Int(maxValue) - integerValue
    }

    func setValue(_ value: Int) {
        let sliderValue = Int(maxValue) - value
        integerValue = sliderValue
    }
}

internal extension Optional where Wrapped == NSSlider {
    var invertedValue: Int {
        guard let slider = self else {
            return 0
        }
        return slider.invertedValue
    }

    func setValue(_ value: Int) {
        guard let slider = self else {
            return
        }
        slider.setValue(value)
    }
}
