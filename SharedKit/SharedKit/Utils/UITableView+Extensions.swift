//
//  UITableView+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 29/5/22.
//

import UIKit

public extension UITableView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }

    func lastIndexpath() -> IndexPath {
        let section = max(numberOfSections - 1, 0)
        let row = max(numberOfRows(inSection: section) - 1, 0)

        return IndexPath(row: row, section: section)
    }
}
