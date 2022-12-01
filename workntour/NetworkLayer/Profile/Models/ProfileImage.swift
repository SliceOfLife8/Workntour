//
//  ProfileImage.swift
//  workntour
//
//  Created by Chris Petimezas on 20/11/22.
//

import Foundation

struct ProfileImage: Codable {
    let id: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "imageId"
        case url = "imageUrl"
    }
}
