//
//  WorkType.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

public enum WorkType {
    case requestPlain
    case requestData(data: Data)
    case requestParameters(parameters: [String: Any], encoding: JSONEncoder = JSONEncoder())
    case requestWithEncodable(encodable: AnyEncodable)
}