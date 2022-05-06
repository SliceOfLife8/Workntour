//
//  AuthorizationRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 2/5/22.
//

import Foundation
import Networking

enum AuthorizationRouter: NetworkTarget {
    case registration
    case resendOtp
    case login

    public var baseURL: URL {
        URL(string: "https://api.publicapis.org")!
    }

    public var path: String {
        switch self {
        case .registration:
            return "/entries"
        case .resendOtp:
            return "/api/resendOtp"
        case .login:
            return "/api/login"
        }
    }

    public var methodType: MethodType {
        .get
    }

    public var workType: WorkType {
        .requestPlain
    }

    public var providerType: AuthProviderType {
        .none
    }

    public var contentType: ContentType? {
        .none
    }

    public var headers: [String: String]? {
        nil
    }
}

// MARK: - Welcome
struct Welcome: Codable {
    let count: Int
    let entries: [Entry]
}

// MARK: - Entry
struct Entry: Codable {
    let api, entryDescription, auth: String
    let https: Bool
    let cors: String
    let link: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case api = "API"
        case entryDescription = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}
