//
//  UIView+Gradient.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 8/6/22.
//

import UIKit

public extension UIView {

    func setGradientLayer(borderWidth: CGFloat, hasError: Bool = false) {
        removeGradientLayers()
        let lineWidth: CGFloat = borderWidth
        let rect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.colors = hasError ? [UIColor.red.cgColor, UIColor.red.cgColor] : [UIColor.appColor(.purple).cgColor, UIColor.appColor(.mint).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)

        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth

        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        layer.addSublayer(gradient)
        layer.masksToBounds = true
    }

    func removeGradientLayers() {
        layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach{ $0.removeFromSuperlayer() }
    }
}
