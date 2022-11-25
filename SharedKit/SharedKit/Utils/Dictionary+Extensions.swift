//
//  Dictionary+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 2/6/22.
//

import Foundation

public extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.filter { $1 == value }.map { $0.0 }.first
    }
}
