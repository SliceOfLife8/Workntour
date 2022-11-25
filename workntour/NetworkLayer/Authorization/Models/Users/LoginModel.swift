//
//  LoginModel.swift
//  workntour
//
//  Created by Chris Petimezas on 9/6/22.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let memberId: String
    let role: UserRole
}
