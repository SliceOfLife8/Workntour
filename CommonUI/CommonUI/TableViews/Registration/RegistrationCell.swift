//
//  RegistrationCell.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 28/5/22.
//

import UIKit

public protocol RegistrationCellDelegate: AnyObject {
    func textFieldDidBeginEditing(cell: RegistrationCell)
}

public class RegistrationCell: UITableViewCell {

    public weak var delegate: RegistrationCellDelegate?

    public static let identifier = String(describing: RegistrationCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var gradientTextField: GradientTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public func setupCell(title: String,
                          isOptional: Bool,
                          placeholder: String,
                          keyboardType: UIKeyboardType,
                          rightIcon: TextFieldRightIcon?,
                          countryFlag: String?,
                          description: String?) {
        titleLabel.text = isOptional ? title : "\(title)*"
        optionalLabel.isHidden = !isOptional
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
    }

    func didStartEditing() {
        self.delegate?.textFieldDidBeginEditing(cell: self)
    }
}
