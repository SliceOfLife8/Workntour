//
//  SpecialDietary.swift
//  workntour
//
//  Created by Chris Petimezas on 19/11/22.
//

import Foundation

enum SpecialDietary: Int, CaseIterable, Codable {
    case NONE = 0
    case VEGAN = 1
    case VEGETARIAN = 2

    var value: String {
        switch self {
        case .VEGAN:
            return "Vegan"
        case .VEGETARIAN:
            return "Vegeterian"
        case .NONE:
            return "None"
        }
    }

    init?(caseName: String) {
        for key in SpecialDietary.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
