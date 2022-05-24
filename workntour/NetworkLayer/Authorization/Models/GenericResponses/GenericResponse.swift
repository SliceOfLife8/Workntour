//
//  GenericResponse.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 24/5/22.
//

import Foundation

// MARK: - GenericResponse
struct GenericResponse<T: Codable>: Codable {
    let data: T?
    let exceptions: ErrorResponse?
    let pagination: Pagination?
}
