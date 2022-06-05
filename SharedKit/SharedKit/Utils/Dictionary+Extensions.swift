//
//  Dictionary+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 2/6/22.
//

import Foundation

public extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}
