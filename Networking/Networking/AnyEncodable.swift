//
//  AnyEncodable.swift
//  Networking
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

public struct AnyEncodable {
    public let wrappedValue: Encodable
    
    public init<E>(_ value: E) where E: Encodable {
        wrappedValue = value
    }
}
