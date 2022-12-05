//
//  AuthorizedDoc.swift
//  workntour
//
//  Created by Chris Petimezas on 4/12/22.
//

import Foundation

struct AuthorizedDoc: Codable {
    let id: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "docId"
        case url = "docUrl"
    }
}
