//
//  Traveler.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 10/5/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let count: Int
    let entries: [Entry]
}

// MARK: - Entry
struct Entry: Codable, Equatable {
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
