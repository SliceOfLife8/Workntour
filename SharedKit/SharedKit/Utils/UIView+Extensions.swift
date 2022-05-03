//
//  UIView+Extensions.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit

// MARK: - Auto Layout Helpers
extension UIView {

    /** Convenience method for programatically adding a subview with constraints. */
    public func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

}
