//
//  Array+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 8/6/22.
//

import Foundation

public extension Array {
    mutating func remove(at indices: [Int]) {
        Set(indices)
            .sorted(by: >)
            .forEach { rmIndex in
                self.remove(at: rmIndex)
            }
    }
}
