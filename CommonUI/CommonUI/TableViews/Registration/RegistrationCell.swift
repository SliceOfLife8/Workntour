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
    func textFieldDidChange(cell: RegistrationCell)
    func showCountryFlags(cell: RegistrationCell)
    func showDropdownList(cell: RegistrationCell)
}

/// Optionals
public extension RegistrationCellDelegate {
    func showDropdownList(cell: RegistrationCell) {}
}

public class RegistrationCell: UITableViewCell {
    
    public weak var delegate: RegistrationCellDelegate?
    
    public static let identifier = String(describing: RegistrationCell.self)

    private var descriptionText: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet public weak var gradientTextField: GradientTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var apdView: UIView!
    @IBOutlet weak var apdDocIcon: UIImageView!

    public override func awakeFromNib() {
        super.awakeFromNib()
        apdView.layer.cornerRadius = 8
        apdDocIcon.image = UIImage(named: "upload_doc", in: Bundle.main, compatibleWith: nil)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        apdView.removeGradientLayers()
        apdView.setGradientLayer(borderWidth: 1)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        gradientTextField.resetView()
        apdView.removeGradientLayers()
        gradientTextField.isHidden = false
        apdView.isHidden = true
    }
    
    public func setupCell(title: String,
                          isRequired: Bool,
                          isOptionalLabelVisible: Bool,
                          placeholder: String,
                          text: String?,
                          type: RegistrationModelType,
                          countryFlag: String?,
                          regionCode: String?,
                          description: String?,
                          error: String?) {
        titleLabel.text = isRequired ? "\(title)*" : title
        optionalLabel.isHidden = !isOptionalLabelVisible
        if type == .apd {
            apdView.isHidden = false
            gradientTextField.isHidden = true
        }
        // Errors
        let hasError = error != nil
        self.descriptionText = description
        showError(error, descriptionText: description)
        // Gradient Text Field
        gradientTextField.configure(placeHolder: placeholder, text: text, countryFlag: countryFlag, regionCode: regionCode, type: type, error: hasError)
        gradientTextField.gradientDelegate = self
    }

    public func showError(_ text: String?, descriptionText: String? = nil) {
        if text != nil { // hasError
            descriptionLabel.text = text
            descriptionLabel.textColor = .red
        } else {
            descriptionLabel.text = descriptionText ?? self.descriptionText
            descriptionLabel.textColor = UIColor.appColor(.gray)
        }
    }
    
    /// We should remove old GradientLayer & draw a new one as there is a problem of drawing correct rounded corners.
    public func roundCorners() {
        gradientTextField.removeGradientLayers()
    }
    
}


extension RegistrationCell: GradientTFDelegate {
    func didChange() {
        self.delegate?.textFieldDidChange(cell: self)
    }

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
