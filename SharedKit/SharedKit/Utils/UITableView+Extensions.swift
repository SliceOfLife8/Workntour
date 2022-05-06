//
//  UITableView+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 6/5/22.
//

import UIKit

extension UITableView {
    public func items<Element>(_ builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) -> ([Element]) -> Void {
        let dataSource = CombineTableViewDataSource(builder: builder)
        return { items in
            dataSource.pushElements(items, to: self)
        }
    }
}
