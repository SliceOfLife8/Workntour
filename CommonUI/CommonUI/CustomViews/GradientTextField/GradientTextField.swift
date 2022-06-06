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
    func shouldReturn()
    func didChange()
    func notEditableTextFieldTriggered()
    func didCountryFlagTapped()
}

public class GradientTextField: UITextFieldPadding {
    // MARK: - Vars
    weak var gradientDelegate: GradientTFDelegate?

    private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()

    private var borderWidth: CGFloat = 1
    private var rightIcon: TextFieldRightIcon? = .none
    private var phoneNumberCode: String?
    private var isEditable: Bool = true
    public var selectedDate: Date?
    public var type: RegistrationModelType?
    /// When are error is occured we should update right icon view. Moreover, it should be revertable, so we need
    public var errorOccured: Bool = false {
        didSet {
            if errorOccured {
                setupRightImage(icon: .alert)
            } else if let icon = rightIcon {
                setupRightImage(icon: icon)
            } else {
                rightView = nil
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
    public func removeGradientLayers(_ newWidth: CGFloat = 1) {
        borderWidth = newWidth
        layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach{ $0.removeFromSuperlayer() }
    }

    /// This method is about configure this custom textField
    /// - Parameters:
    ///   - placeHolder: The placeholder of textField
    ///   - text: The placeholder of textField
    ///   - countryFlag: Specify the country flag as an emoji.
    ///   - regionCode: Region code of user's country. f.e. for Greece is +30
    ///   - type: Custom business model for textFields setup.
    ///   - error: Generic error about text of textField
    public func configure(placeHolder: String,
                          text: String?,
                          countryFlag: String?,
                          regionCode: String?,
                          type: RegistrationModelType,
                          error: Bool) {

        attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                   attributes: [
                                                    .foregroundColor: UIColor.appColor(.placeholder),
                                                    .font: UIFont.scriptFont(.regular, size: 16)])

        self.text = text
        textColor = UIColor.appColor(.basicText)
        font = UIFont.scriptFont(.regular, size: 16)

        self.type = type
        changeFlag(countryFlag: countryFlag, regionCode: regionCode)

        switch type {
        case .email:
            self.keyboardType = .emailAddress
        case .password, .verifyPassword:
            self.isSecureTextEntry = true
        case .phone:
            self.keyboardType = .numberPad
        case .nationality, .sex:
            self.isEditable = false
            self.rightIcon = .downArrow
        case .age:
            self.rightIcon = .downArrow
            createDatePicker()
        default:
            break
        }

        self.errorOccured = error
    }

    public func resetView() {
        isEditable = true
        rightIcon = nil
        type = nil
        isSecureTextEntry = false
        keyboardType = .default
        rightView = nil
        leftView = nil
        inputView = nil
        inputAccessoryView = nil
    }

    public func changeFlag(countryFlag: String?, regionCode: String?) {
        self.phoneNumberCode = regionCode
        if let flag = countryFlag {
            setupCountryIcon(flag)
        }
    }

    private func createDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: bounds.width, height: 44.0)))
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        /// Assign toolbar
        self.inputAccessoryView = toolbar
        /// Assign date picker to textField
        self.inputView = datePicker
    }

    // Masked number typing
    /// mask example: `+X (XXX) XXX-XXXX`
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" || ch == "Y" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }

    @objc private func doneTapped() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        selectedDate = datePicker.date

        text = formatter.string(from: datePicker.date)
        resignFirstResponder()
    }

}

// MARK: - TextFieldDelegate
extension GradientTextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.gradientDelegate?.didStartEditing()
        errorOccured = false
        removeGradientLayers(3)
    }

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        // self.gradientDelegate?.didChange()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        removeGradientLayers(1)
        arrowTapped()
        self.gradientDelegate?.didChange()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.gradientDelegate?.shouldReturn()
        return false
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        /// Prevent keyboard appearing & stop editing when isEditable has been set as false.
        DispatchQueue.main.async {
            self.arrowTapped()
        }
        /// Delegate info in order to present drop-down list.
        if !isEditable {
            self.gradientDelegate?.notEditableTextFieldTriggered()
        }

        return isEditable
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }

        if let code = phoneNumberCode {
            let newString = (text as NSString).replacingCharacters(in: range, with: string).replacingOccurrences(of: code, with: "")
            let formattedNum = format(with: "(XXX) XXX-XXXX", phone: newString)

            textField.text = formattedNum.isEmpty ? String() : "+\(code) \(formattedNum)"

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

        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 58, height: 42)))
        containerView.isUserInteractionEnabled = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        containerView.backgroundColor = UIColor.appColor(.lightGray)
        containerView.addSubview(countryFlag)
        containerView.addSubview(arrow)

        leftView = containerView
        leftViewMode = .always
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryViewTapped)))
    }

    @objc public func arrowTapped() {
        /// We should rotate arrow 180˚ when it's available
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
            self.rightView?.transform = (self.rightView?.transform == .identity) ? CGAffineTransform(rotationAngle: .pi) : .identity
        })
    }

    @objc private func countryViewTapped() {
        self.gradientDelegate?.didCountryFlagTapped()
    }
}
