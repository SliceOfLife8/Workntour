//
//  RegistrationError.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/6/22.
//

import Foundation

enum RegistrationError {
    case fullname
    case email
    case password
    case confirmPassword
    case age
    case phoneNumber

    var description: String {
        switch self {
        case .fullname:
            return "It seems that this field is empty!"
        case .email:
            return "Email format is wrong!"
        case .password:
            return "The password does not meet the password policy requirements."
        case .confirmPassword:
            return "Verify your password."
        case .age:
            return "Age should be greater than 18 years old."
        case .phoneNumber:
            return "Phone number should contains exactly 10 digits"
        }
    }
}
