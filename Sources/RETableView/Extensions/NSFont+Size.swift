//
//  NSFont+Size.swift
//  TableView
//
//  Created by Александр Васильченко on 04.02.2021.
//

import Cocoa

internal extension NSFont {
    var height: CGFloat {
        return ceil(boundingRectForFont.height)
    }
}
