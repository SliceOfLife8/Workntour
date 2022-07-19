//
//  Extension+CaseIterable.swift
//  SharedKit
//
//  Created by Petimezas, Chris, Vodafone on 18/7/22.
//

import Foundation

public extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
