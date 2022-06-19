//
//  UserDataManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 19/6/22.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()

    /// Basic structure
    var memberID: String = ""
    var role: UserRole? = .none

    func updateUser(_ model: LoginModel) {
        self.memberID = model.memberId
        self.role = model.role
    }

}
