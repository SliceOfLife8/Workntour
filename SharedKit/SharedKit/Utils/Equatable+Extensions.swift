//
//  Equatable+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 28/5/22.
//

import Foundation

public extension Equatable {
    func oneOf(other: Self...) -> Bool {
        return other.contains(self)
    }
}
