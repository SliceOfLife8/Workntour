//
//  RegistrationModel.swift
//  workntour
//
//  Created by Chris Petimezas on 28/5/22.
//

import UIKit
import CommonUI

struct RegistrationModel: Hashable {
    let title: String
    let isRequired: Bool
    let optionalTextVisible: Bool
    let placeholder: String
    let type: GradientTextFieldType
    let countryEmoji: String?
    let countryPrefixCode: String?
    let description: String?
    let errorMessage: String?
    let error: String?

    init(title: String, isRequired: Bool = true, optionalTextVisible: Bool = false,
         placeholder: String, type: GradientTextFieldType, countryEmoji: String? = nil,
         prefixCode: String? = nil, description: String? = nil, errorMessage: String? = nil, error: String? = nil) {
        self.title = title
        self.isRequired = isRequired
        self.optionalTextVisible = optionalTextVisible
        self.placeholder = placeholder
        self.type = type
        self.countryEmoji = countryEmoji
        self.countryPrefixCode = prefixCode
        self.description = description
        self.errorMessage = errorMessage
        self.error = error
    }
}
