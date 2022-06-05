//
//  RegistrationView.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 2/6/22.
//

import UIKit

//public protocol RegistrationCellDelegate: AnyObject {
//    func textFieldDidBeginEditing(cell: RegistrationCell)
//    func textFieldShouldReturn(cell: RegistrationCell)
//    func textFieldDidChange(cell: RegistrationCell, newText: String?)
//    func showCountryFlags(cell: RegistrationCell)
//    func showDropdownList(cell: RegistrationCell)
//}

public class RegistrationView: UIView, CustomViewProtocol {

    // public weak var delegate: RegistrationCellDelegate?

    private var descriptionText: String?

    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gradientTextField: GradientTextField!

    // MARK: - Inits
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(for: RegistrationView.self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(for: RegistrationView.self)
    }

    public func setup(title: String,
                          isRequired: Bool,
                          isOptionalLabelVisible: Bool,
                          placeholder: String,
                          text: String?,
                          type: RegistrationModelType,
                          countryFlag: String?,
                          regionCode: String?,
                          description: String?,
                          error: String?) {

        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        titleLabel.text = isRequired ? "\(title)*" : title
        optionalLabel.isHidden = !isOptionalLabelVisible
        let hasError = error != nil
        descriptionText = description

        gradientTextField.configure(placeHolder: placeholder, text: text, countryFlag: countryFlag, regionCode: regionCode, type: type, error: hasError)
        gradientTextField.gradientDelegate = self

        if let error = error {
            descriptionLabel.text = error
            descriptionLabel.textColor = .red
        } else {
            descriptionLabel.text = description
            descriptionLabel.textColor = UIColor.appColor(.gray)
        }
    }

    /// We should remove old GradientLayer & draw a new one as there is a problem of drawing correct rounded corners.
    public func roundCorners() {
        gradientTextField.removeGradientLayers()
    }
}


extension RegistrationView: GradientTFDelegate {
    func notEditableTextFieldTriggered() {
        //self.delegate?.showDropdownList(cell: self)
    }

    func didCountryFlagTapped() {
        //self.delegate?.showCountryFlags(cell: self)
    }

    func didStartEditing() {
        //self.delegate?.textFieldDidBeginEditing(cell: self)
        descriptionLabel.text = descriptionText
        descriptionLabel.textColor = UIColor.appColor(.gray)
    }

    func shouldReturn() {
        //self.delegate?.textFieldShouldReturn(cell: self)
    }

    func didChange(_ text: String?) {
        //self.delegate?.textFieldDidChange(cell: self, newText: text)
    }
}
