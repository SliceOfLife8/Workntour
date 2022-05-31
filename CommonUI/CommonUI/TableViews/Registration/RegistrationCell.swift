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
    func showCountryFlags(cell: RegistrationCell)
    func showDropdownList(cell: RegistrationCell)
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
                          type: RegistrationModelType,
                          countryFlag: String?,
                          regionCode: String?,
                          description: String?) {
        titleLabel.text = isRequired ? "\(title)*" : title
        optionalLabel.isHidden = !isOptionalLabelVisible
        descriptionLabel.text = description
        
        gradientTextField.configure(placeHolder: placeholder, countryFlag: countryFlag, regionCode: regionCode, type: type)
        gradientTextField.gradientDelegate = self
    }
    
    /// We should remove old GradientLayer & draw a new one as there is a problem of drawing correct rounded corners.
    public func roundCorners() {
        gradientTextField.removeGradientLayers()
    }
    
}


extension RegistrationCell: GradientTFDelegate {
    func notEditableTextFieldTriggered() {
        self.delegate?.showDropdownList(cell: self)
    }
    
    func didCountryFlagTapped() {
        self.delegate?.showCountryFlags(cell: self)
    }
    
    func didStartEditing() {
        self.delegate?.textFieldDidBeginEditing(cell: self)
    }
    
    func shouldReturn() {
        self.delegate?.textFieldShouldReturn(cell: self)
    }
}
