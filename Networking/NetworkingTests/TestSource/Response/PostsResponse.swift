//
//  PostsResponse.swift
//  NetworkingTests
//
//  Created by Chris Petimezas on 1/5/22.
//

import Foundation

typealias PostsResponse = [PostResponseElement]

struct PostResponseElement: Decodable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
