//
//  AuthorizationRouter.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation
import Networking

/*
 Create a generic class Router to provide required properties for this type of classes.
 Only this layer should know about networking!
 */

enum MockTarget {
    case test
}

extension MockTarget: NetworkTarget {
    var baseURL: URL {
        URL(string: "https://api.publicapis.org")!
    }

    var path: String {
        "/entries"
    }

    var methodType: MethodType {
        .get
    }

    var workType: WorkType {
        .requestPlain
    }

    var providerType: AuthProviderType {
        .none
    }
    
    var contentType: ContentType? {
        .none
    }

    var headers: [String : String]? {
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
