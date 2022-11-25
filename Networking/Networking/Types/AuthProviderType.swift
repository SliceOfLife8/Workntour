//
//  AuthProviderType.swift
//  Networking
//
//  Created by Chris Petimezas on 1/5/22.
//

import Foundation

public enum AuthProviderType {
    case bearer(token: String)
    case basic(username: String, password: String)
    case none
}
