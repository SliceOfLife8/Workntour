//
//  OpportunityCoordinateModel.swift
//  workntour
//
//  Created by Chris Petimezas on 20/7/22.
//

import Foundation

struct OpportunityCoordinateModel: Codable {
    let id: String
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case id = "opportunityId"
        case longitude, latitude
    }
}
