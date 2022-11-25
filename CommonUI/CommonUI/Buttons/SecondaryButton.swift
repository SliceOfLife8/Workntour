//
//  SecondaryButton.swift
//  CommonUI
//
//  Created by Chris Petimezas on 25/5/22.
//

import UIKit
import SharedKit

public class SecondaryButton: UIButton {
    // MARK: - Customize your view
    @IBInspectable public var radius: CGFloat = 0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable public var mainColor: UIColor = .black {
        didSet {
            setUp()
        }
    }

    public override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                mainColor = UIColor(hexString: "#ADADAD")
            } else {
                mainColor = UIColor.appColor(.purple)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    override open var intrinsicContentSize: CGSize {
        let intrinsicContentSize = super.intrinsicContentSize

        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }

    private func setUp() {
        sizeToFit()
        addBorder()

        setTitleColor(mainColor, for: .normal)
        titleLabel?.textColor = mainColor
        titleLabel?.font = UIFont.scriptFont(.semibold, size: 16)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIImpactFeedbackGenerator.impact(.soft)
    }

    public override var isHighlighted: Bool {
        didSet {
            let xScale: CGFloat = isHighlighted ? 0.975 : 1.0
            let yScale: CGFloat = isHighlighted ? 0.95 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }

    private func addBorder() {
        backgroundColor = .clear
        layer.cornerRadius = radius
        layer.borderWidth = 1
        layer.borderColor = mainColor.cgColor
    }
}
