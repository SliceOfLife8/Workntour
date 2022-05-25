//
//  PrimaryButton.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 25/5/22.
//

import UIKit

public class PrimaryButton: UIButton {
    // MARK: - Customize your view
    @IBInspectable public var radius: CGFloat = 0 {
        didSet {
            setUp()
        }
    }
    @IBInspectable public var enabledStateColor: UIColor = .black {
        didSet {
            setUp()
        }
    }
    @IBInspectable public var disabledStateColor: UIColor = .black {
        didSet {
            setUp()
        }
    }
    @IBInspectable public var enabledStateTitleColor: UIColor = .white {
        didSet {
            setUp()
        }
    }
    @IBInspectable public var disabledStateTitleColor: UIColor = .white {
        didSet {
            setUp()
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

    public override var isEnabled: Bool {
        didSet {
            if isEnabled {
                setEnabledState()
            } else {
                setDisableState()
            }
        }
    }

    override open var intrinsicContentSize: CGSize {
        let intrinsicContentSize = super.intrinsicContentSize

        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }

    private func setUp() {
        sizeToFit()
        layer.cornerRadius = radius
        clipsToBounds = true
        addShadow()

        if isEnabled {
            setEnabledState()
        } else {
            setDisableState()
        }
    }

    func setEnabledState() {
        backgroundColor = enabledStateColor
        setTitleColor(enabledStateTitleColor, for: .normal)
        titleLabel?.font = UIFont(name: "Inter", size: 16)
    }

    func setDisableState() {
        backgroundColor = disabledStateColor
        setTitleColor(disabledStateColor, for: .disabled)
        titleLabel?.font = UIFont(name: "Inter", size: 16)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIImpactFeedbackGenerator.impact(.light)
    }

    public override var isHighlighted: Bool {
        didSet {
            let xScale: CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale: CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }

    private func addShadow() {
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = enabledStateColor.cgColor
        layer.masksToBounds = false
    }
}
