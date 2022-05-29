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
    let isRequired: Bool
    let optionalTextVisible: Bool
    let placeholder: String
    let textFieldKeyboardType: UIKeyboardType
    let textFieldRightIcon: TextFieldRightIcon?
    let countryEmoji: String?
    let description: String?

    init(title: String, isRequired: Bool = true, optionalTextVisible: Bool = false,
         placeholder: String, textFieldKeyboardType: UIKeyboardType = .default,
         rightIcon: TextFieldRightIcon? = nil, countryEmoji: String? = nil, description: String? = nil) {
        self.title = title
        self.isRequired = isRequired
        self.optionalTextVisible = optionalTextVisible
        self.placeholder = placeholder
        self.textFieldKeyboardType = textFieldKeyboardType
        self.textFieldRightIcon = rightIcon
        self.countryEmoji = countryEmoji
        self.description = description
    }
}
