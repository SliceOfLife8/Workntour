//
//  TravelerUpdatedBody.swift
//  workntour
//
//  Created by Chris Petimezas on 20/11/22.
//

import Foundation

struct TravelerUpdatedBody: Codable {
    let updatedTravelerProfile: TravelerProfileDto
    let media: Media?
}
