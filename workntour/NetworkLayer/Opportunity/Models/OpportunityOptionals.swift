//
//  OpportunityOptionals.swift
//  workntour
//
//  Created by Chris Petimezas on 27/1/23.
//

import Foundation

struct OpportunityOptionals: Hashable, Codable {
    let additionalOfferings: [AdditionalOfferings]?
    let languagesSpoken: [Language]?
    let experience: String?
    let specialDietary: SpecialDietary?
    let coupleAccepted: Bool?
    let wifi: Bool?
    let smokingAllowed: Bool?
    let petsAllowed: Bool?
}

enum AdditionalOfferings: String, CaseIterable, Codable {
    case FREE_LAUNDRY
    case FREE_TOURS
    case FREE_DRINKS
    case FREE_TRANSPORTATION
    case PICK_UP
    case YOGA
    case SURF
    case DANCE
    case LANGUAGE

    var value: String {
        switch self {
        case .FREE_LAUNDRY:
            return "Free Laundry"
        case .FREE_TOURS:
            return "Free Tours"
        case .FREE_DRINKS:
            return "Free Drinks"
        case .FREE_TRANSPORTATION:
            return "Free Transportation"
        case .PICK_UP:
            return "Pick up from Airport/Port"
        case .YOGA:
            return "Yoga classes"
        case .SURF:
            return "Surf lessons"
        case .DANCE:
            return "Dance Classes"
        case .LANGUAGE:
            return "Language Lessons"
        }
    }

    init?(caseName: String) {
        for key in AdditionalOfferings.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
