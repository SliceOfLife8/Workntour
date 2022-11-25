//
//  UINavigationController+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 29/6/22.
//

import UIKit

public extension UINavigationController {
    var previousViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}
