// ----------------------------------------------------------------------------
//
//  RETableViewDelegate.swift
//
//  @author     Alexander Vasilchenko <alexfreud@me.com>
//  @copyright  Copyright (c) 2021. All rights reserved.
//  @link       https://re-amp.ru/
//
// ----------------------------------------------------------------------------

import Foundation

public protocol RETableViewDelegate: class {
    /// Return the number of rows in a table view.
    var numberOfRows: Int { get }

    /// Item to insert in a particular location of the table view.
    /// - Parameter index: An index locating a row in tableView.
    func getItem(at index: Int) -> RETableViewItem

    /// Add dragged URLs at index position
    /// - Parameters:
    ///   - urls: Array of dragged URLs
    ///   - index: Index, where URLs must be inserted
    func add(_ urls: [URL], at index: Int)

    /// Doubleclicked or enter-pressed item index
    /// - Parameter index: Item index
    func itemDidPressed(at index: Int)

    /// Selected items in table
    /// - Parameter indexSet: Set of selected items indexes
    func didSelect(rows indexSet: Set<Int>)

    /// Items to be removed from table
    /// - Parameter indexSet: Indexes of removable items
    func didRemove(indexSet: Set<Int>)

    /// Begin items moving in table
    func didBeginMovingItems()

    /// End items moving in table
    func didEndMovingItems()

    /// Moving items in table
    /// - Parameters:
    ///   - difference: Step by which the elements in the table have shifted
    ///   - movingIndexes: Moving items indexes
    func didMoveItems(difference: Int, movingIndexes: Set<Int>)
}
