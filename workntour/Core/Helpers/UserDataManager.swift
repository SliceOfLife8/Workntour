//
//  UserDataManager.swift
//  workntour
//
//  Created by Chris Petimezas on 19/6/22.
//

import Foundation

class UserDataManager {
    static let shared = UserDataManager()

    /// Basic structure
    var role: UserRole? = .none
    var memberId: String?
    var data: Data?

    func save<T: Codable>(_ value: T,
                          memberId: String?,
                          role: UserRole?) {
        self.memberId = memberId
        self.role = role
        self.data = try? JSONEncoder().encode(value)
    }

    func retrieve<T: Codable>(_ type: T.Type) -> T? {
        guard let _data = data else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: _data)
    }

    func clearCache() {
        role = .none
        memberId = nil
        data = nil
    }

}
