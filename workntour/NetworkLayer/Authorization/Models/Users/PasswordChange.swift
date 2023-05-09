//
//  PasswordChange.swift
//  workntour
//
//  Created by Chris Petimezas on 9/5/23.
//

import Foundation

// MARK: - PasswordChange
struct PasswordChange: Codable {
    let token: String
    let password: String
}
