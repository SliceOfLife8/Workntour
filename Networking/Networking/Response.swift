//
//  Response.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

public struct Response {
    let urlResponse: HTTPURLResponse
    let data: Data
    
    var statusCode: Int { urlResponse.statusCode }
    var localizedStatusCodeDescription: String { HTTPURLResponse.localizedString(forStatusCode: statusCode) }
}
