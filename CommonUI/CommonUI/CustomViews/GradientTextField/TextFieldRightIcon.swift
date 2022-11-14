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
    case showPassword
    case hidePassword

    var imageName: String {
        switch self {
        case .alert:
            return "alert-circle"
        case .upArrow:
            return "chevron-up"
        case .downArrow:
            return "chevron-down"
        case .showPassword:
            return "password_reveal"
        case .hidePassword:
            return "password_hide"
        }
    }
}

public enum GradientTextFieldType {
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
    case fixedNumber
    case opportunityCategory
    case typeOfHelp
    case languagesRequired
    case languagesSpoken
    case accommodation
    case learningOpportunities
    case travelerType
    // New format -- We should use only these types
    case plain
    case date
    case noEditable
}
