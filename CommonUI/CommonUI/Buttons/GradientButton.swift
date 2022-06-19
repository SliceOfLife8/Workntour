//
//  GradientButton.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 19/6/22.
//

import UIKit

@IBDesignable
public class GradientButton: UIButton {

    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable public var gradientColor1: CGColor = UIColor(hexString: "#7E6FD8").cgColor
    @IBInspectable public var gradientColor2: CGColor = UIColor(hexString: "#0EE5D0").cgColor

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [gradientColor1, gradientColor2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }()
}
