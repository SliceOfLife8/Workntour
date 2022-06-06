//
//  TextFieldRightIcon.swift
//  CommonUI
//
//  Created by Petimezas, Chris, Vodafone on 27/5/22.
//

import Foundation

public enum TextFieldRightIcon {
    case alert
    case upArrow
    case downArrow

    var imageName: String {
        switch self {
        case .alert:
            return "alert-circle"
        case .upArrow:
            return "chevron-up"
        case .downArrow:
            return "chevron-down"
        }
    }
}

public enum RegistrationModelType {
    case name
    case surname
    case email
    case password
    case verifyPassword
    case age
    case phone
    case nationality
    case sex
    case vatNumber
    case apd
}
