//
//  Media.swift
//  workntour
//
//  Created by Chris Petimezas on 28/11/22.
//

import SharedKit

struct Media: Codable {
    let key: String
    let data: Data
    let fileName: String
    let mimeType: String

    init(data: Data, forKey key: String, withName name: String?) {
        self.key = key
        self.data = data
        self.mimeType = data.mimeType()
        self.fileName = name ?? "\(arc4random()).jpeg"
    }
}
