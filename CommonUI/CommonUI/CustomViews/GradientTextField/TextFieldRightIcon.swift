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
