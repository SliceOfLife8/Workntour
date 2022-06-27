//
//  UIView+Extensions.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit

public typealias AxisYAnchor = (anchor: NSLayoutYAxisAnchor, constant: CGFloat)
public typealias AxisXAnchor = (anchor: NSLayoutXAxisAnchor, constant: CGFloat)

// MARK: - Auto Layout Helpers
extension UIView {

    /** Convenience method for programatically adding a subview with constraints. */
    public func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    /** Automatically add constraints */
    public func addExclusiveConstraints(superview: UIView, top: AxisYAnchor? = nil, bottom: AxisYAnchor? = nil, left: AxisXAnchor? = nil, right: AxisXAnchor? = nil, width: CGFloat? = nil, height: CGFloat? = nil, centerX: AxisXAnchor? = nil, centerY: AxisYAnchor? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        if let top = top {
            self.topAnchor.constraint(equalTo: top.anchor, constant: top.constant).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom.anchor, constant: -bottom.constant).isActive = true
        }
        if let left = left {
            self.leadingAnchor.constraint(equalTo: left.anchor, constant: left.constant).isActive = true
        }
        if let right = right {
            self.trailingAnchor.constraint(equalTo: right.anchor, constant: -right.constant).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX.anchor, constant: centerX.constant).isActive = true
        }
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY.anchor, constant: centerY.constant).isActive = true
        }
    }

    public func makeCorner(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.isOpaque = false
    }

}
