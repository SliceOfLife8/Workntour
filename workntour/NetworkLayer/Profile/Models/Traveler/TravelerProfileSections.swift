//
//  TravelerProfileSections.swift
//  workntour
//
//  Created by Chris Petimezas on 19/11/22.
//

import Foundation

enum TravelerProfileSection: Int, CaseIterable {
    case personalInfo = 0
    case description = 1
    case typeOfTraveler = 2
    case interests = 3
    case languages = 4
    case skills = 5
    case experience = 6

    var value: String {
        switch self {
        case .personalInfo:
            return "Personal Info"
        case .description:
            return "Describe Yourself"
        case .typeOfTraveler:
            return "Type of traveler"
        case .interests:
            return "Interests"
        case .languages:
            return "Languages"
        case .skills:
            return "Skills"
        case .experience:
            return "Experience"
        }
    }
}
