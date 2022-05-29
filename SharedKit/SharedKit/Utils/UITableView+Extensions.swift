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
}
