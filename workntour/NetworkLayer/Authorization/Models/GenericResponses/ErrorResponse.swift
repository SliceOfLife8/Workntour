//
//  ErrorResponse.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 24/5/22.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let total: Int?
    let errors: [ErrorDetails]?
}

// MARK: - ErrorDetails
struct ErrorDetails: Codable {
    let code: Int?
    let debug, title, errorDescription, exceptionCode: String?
    let redirect, datetime: String?

    enum CodingKeys: String, CodingKey {
        case code, debug, title
        case errorDescription = "description"
        case exceptionCode, redirect, datetime
    }
}

struct NoReply: Codable {}
