//
//  GradientTextField.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 27/5/22.
//

import UIKit
import SharedKit

protocol GradientTFDelegate: AnyObject {
    func didStartEditing()
    func didArrowTapped()
    func didCountryFlagTapped()
}

public class GradientTextField: UITextFieldPadding {
    // MARK: - Vars
    weak var gradientDelegate: GradientTFDelegate?

    private var borderWidth: CGFloat = 1
    private var rightIcon: TextFieldRightIcon? = .none
    /// When are error is occured we should update right icon view. Moreover, it should be revertable, so we need
    public var errorOccured: Bool = false {
        didSet {
            if errorOccured {
                setupRightImage(icon: .alert)
            } else if let icon = rightIcon {
                setupRightImage(icon: icon)
            }
        }
    }

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    func commonInit() {
        tintColor = UIColor.appColor(.purple)
        delegate = self
        clipsToBounds = true
        layer.cornerRadius = 8
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientLayer()
    }

    /// Add GradientLayer as a border outside of textField
    private func setupGradientLayer() {
        if errorOccured {
            borderWidth = 1
        }
        let lineWidth: CGFloat = borderWidth
        let rect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.colors = errorOccured ? [UIColor.red.cgColor, UIColor.red.cgColor] : [UIColor.appColor(.purple).cgColor, UIColor.appColor(.mint).cgColor]
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

    /// This method is about to remove previous gradientLayers before starting to draw again.
    func removeGradientLayers(_ newWidth: CGFloat = 1) {
        borderWidth = newWidth
        layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach{ $0.removeFromSuperlayer() }
    }

    /// This method is about configure this custom textField
    /// - Parameters:
    ///   - placeHolder: The placeholder of textField
    ///   - keyboardType: User can specify the type of keyboard. f.e. he could define it as .emailAddress for email purposes.
    ///   - rightIcon: The rightView of textField. Add your icon inside 'TextFieldRightIcon' enum
    ///   - countryFlag: Specify the country flag as an emoji.
    public func configure(placeHolder: String,
                          keyboardType: UIKeyboardType,
                          rightIcon: TextFieldRightIcon?,
                          countryFlag: String?) {

        resetView()
        attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                   attributes: [
                                                    .foregroundColor: UIColor.appColor(.placeholder),
                                                    .font: UIFont.scriptFont(.regular, size: 16)])

        textColor = UIColor.appColor(.basicText)
        font = UIFont.scriptFont(.regular, size: 16)

        self.keyboardType = keyboardType
        self.rightIcon = rightIcon

        if let flag = countryFlag {
            setupCountryIcon(flag)
        }
        self.errorOccured = false
    }

    private func resetView() {
        rightView = nil
        leftView = nil
    }

}

// MARK: - TextFieldDelegate
extension GradientTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.gradientDelegate?.didStartEditing()
        errorOccured = false
        removeGradientLayers(3)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing!")
        removeGradientLayers(1)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        /// Prevent keyboard appearing & stop editing when rightIcon has been set as an arrow.
        if rightIcon?.oneOf(other: .upArrow, .downArrow) == true {
            arrowTapped()
            return false
        }
        return true
    }
}

// MARK: - Add icons
extension GradientTextField {
    private func setupRightImage(icon: TextFieldRightIcon) {
        let imageView = UIImageView(frame: CGRect(x: 12, y: 12, width: 16, height: 16))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: icon.imageName)
        imageView.contentMode = .center
        let imageContainerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always

        if icon.oneOf(other: .upArrow, .downArrow) == true {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowTapped)))
        }
    }

    private func setupCountryIcon(_ emoji: String) {
        let countryFlag = UILabel(frame: CGRect(x: 13, y: 10, width: 24, height: 24))
        countryFlag.text = emoji

        let arrow = UIImageView(frame: CGRect(x: 43, y: 20, width: 9.5, height: 6))
        arrow.image = UIImage(named: "down_arrow")

        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 58, height: bounds.height)))
        containerView.isUserInteractionEnabled = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        containerView.backgroundColor = UIColor.appColor(.lightGray)
        containerView.addSubview(countryFlag)
        containerView.addSubview(arrow)

        leftView = containerView
        leftViewMode = .always
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryViewTapped)))
    }

    @objc private func arrowTapped() {
        self.gradientDelegate?.didArrowTapped()

        /// We should rotate arrow when it's available
        if rightView?.transform == .identity {
            rightView?.transform = CGAffineTransform(rotationAngle: .pi) // 180˚
        } else {
            rightView?.transform = .identity
        }
    }

    @objc private func countryViewTapped() {
        self.gradientDelegate?.didCountryFlagTapped()
    }
}
