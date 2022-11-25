//
//  Pagination.swift
//  workntour
//
//  Created by Chris Petimezas on 24/5/22.
//

import Foundation

// MARK: - Pagination
struct Pagination: Codable {
    let paginationSelf, total, next, prev: Int?

    enum CodingKeys: String, CodingKey {
        case paginationSelf = "self"
        case total, next, prev
    }
}
