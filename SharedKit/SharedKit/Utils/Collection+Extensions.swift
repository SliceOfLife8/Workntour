//
//  Collection+Extensions.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 6/7/22.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
