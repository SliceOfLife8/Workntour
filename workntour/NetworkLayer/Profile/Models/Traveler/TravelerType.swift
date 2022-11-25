//
//  TravelerType.swift
//  workntour
//
//  Created by Chris Petimezas on 1/8/22.
//

import Foundation

enum TravelerType: String, CaseIterable, Codable {
    case SOLO_TRAVELER
    case COUPLE
    case FRIENDS
    case CAREER_BREAK
    case GAP_YEAR
    case STUDENT
    case FAMILY
    case DIGITAL_NOMAD

    var value: String {
        switch self {
        case .SOLO_TRAVELER:
            return "Solo traveler"
        case .COUPLE:
            return "Couple"
        case .FRIENDS:
            return "Friends"
        case .CAREER_BREAK:
            return "Career break"
        case .GAP_YEAR:
            return "Gap year"
        case .STUDENT:
            return "Student"
        case .FAMILY:
            return "Family"
        case .DIGITAL_NOMAD:
            return "Digital nomad"
        }
    }

    init?(caseName: String) {
        for key in TravelerType.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
