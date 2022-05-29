//
//  RegistrationModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 28/5/22.
//

import UIKit
import CommonUI

struct RegistrationModel: Hashable {
    let title: String
    let isOptional: Bool
    let placeholder: String
    let textFieldKeyboardType: UIKeyboardType
    let textFieldRightIcon: TextFieldRightIcon?
    let countryEmoji: String?
    let description: String?

    init(title: String, isOptional: Bool = false, placeholder: String, textFieldKeyboardType: UIKeyboardType = .default, rightIcon: TextFieldRightIcon? = nil, countryEmoji: String? = nil, description: String? = nil) {
        self.title = title
        self.isOptional = isOptional
        self.placeholder = placeholder
        self.textFieldKeyboardType = textFieldKeyboardType
        self.textFieldRightIcon = rightIcon
        self.countryEmoji = countryEmoji
        self.description = description
    }
}
