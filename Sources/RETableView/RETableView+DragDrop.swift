// ----------------------------------------------------------------------------
//
//  RETableView+DragDrop.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Cocoa

extension RETableView {

    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }

    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteBoard = sender.draggingPasteboard
        let dragLocation = convert(sender.draggingLocation, from: nil)
        let index = (offset + Int(dragLocation.y / theme.font.height)) + 1
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self]) as? [URL], urls.count > 0 {
            delegate?.add(urls, at: index)
        }
        return true
    }

}
