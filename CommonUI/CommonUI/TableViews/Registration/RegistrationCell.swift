//
//  RegistrationCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 28/5/22.
//

import UIKit

public protocol RegistrationCellDelegate: AnyObject {
    func textFieldDidBeginEditing(cell: RegistrationCell)
    func textFieldShouldReturn(cell: RegistrationCell)
}

public class RegistrationCell: UITableViewCell {

    public weak var delegate: RegistrationCellDelegate?

    public static let identifier = String(describing: RegistrationCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet public weak var gradientTextField: GradientTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public func setupCell(title: String,
                          isRequired: Bool,
                          isOptionalLabelVisible: Bool,
                          placeholder: String,
                          keyboardType: UIKeyboardType,
                          rightIcon: TextFieldRightIcon?,
                          countryFlag: String?,
                          description: String?) {
        titleLabel.text = isRequired ? "\(title)*" : title
        optionalLabel.isHidden = !isOptionalLabelVisible
        descriptionLabel.text = description

        gradientTextField.configure(placeHolder: placeholder, keyboardType: keyboardType, rightIcon: rightIcon, countryFlag: countryFlag)
        gradientTextField.gradientDelegate = self
    }

    /// We should remove old GradientLayer & draw a new one as there is a problem of drawing correct rounded corners.
    public func roundCorners() {
        gradientTextField.removeGradientLayers()
    }
    
}

extension RegistrationCell: GradientTFDelegate {
    func didArrowTapped() {
    }

    func didCountryFlagTapped() {
        print("show menu!!!")
    }

    func didStartEditing() {
        self.delegate?.textFieldDidBeginEditing(cell: self)
    }

    func shouldReturn() {
        self.delegate?.textFieldShouldReturn(cell: self)
    }
}
