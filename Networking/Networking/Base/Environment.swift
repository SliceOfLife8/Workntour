//
//  Environment.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

public struct Environment {
    public init(
        jsonSerializationData: @escaping (Any, JSONSerialization.WritingOptions) throws -> Data = JSONSerialization.data(withJSONObject:options:),
        printDebugDescriptionIfNeeded: @escaping (URLRequest, Error?) -> Void = NetworkingDebugger.printDebugDescriptionIfNeeded(from:error:))
    {
        self.jsonSerializationData = jsonSerializationData
        self.printDebugDescriptionIfNeeded = printDebugDescriptionIfNeeded
    }

    public var jsonSerializationData: (Any, JSONSerialization.WritingOptions) throws -> Data
    public var printDebugDescriptionIfNeeded: (URLRequest, Error?) -> Void
}
