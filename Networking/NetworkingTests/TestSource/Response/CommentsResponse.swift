//
//  CommentsResponse.swift
//  NetworkingTests
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

struct CommentsResponseElement: Decodable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}

typealias CommentsResponse = [CommentsResponseElement]
