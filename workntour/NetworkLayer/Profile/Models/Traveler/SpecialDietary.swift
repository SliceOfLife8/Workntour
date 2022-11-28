//
//  SpecialDietary.swift
//  workntour
//
//  Created by Chris Petimezas on 19/11/22.
//

import Foundation

enum SpecialDietary: String, CaseIterable, Codable {
    case NONE
    case VEGAN
    case VEGETARIAN

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

    var intValue: Int {
        switch self {
        case .NONE:
            return 0
        case .VEGAN:
            return 1
        case .VEGETARIAN:
            return 2
        }
    }

    init?(_ value: Int) {
        for key in SpecialDietary.allCases where key.intValue == value {
            self = key
            return
        }

        return nil
    }

    init?(caseName: String) {
        for key in SpecialDietary.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
