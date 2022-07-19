//
//  OpportunityEnums.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 5/7/22.
//

import Foundation

enum Meal: String, CaseIterable, Codable {
    case breakfast
    case lunch
    case dinner
    case useSharedKitchen

    var value: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        case .useSharedKitchen:
            return "Use shared kitchen"
        }
    }

    init?(caseName: String) {
        for key in Meal.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}

enum Language: String, CaseIterable, Codable {
    case greek
    case english
    case spanish
    case italian
    case german

    var value: String {
        switch self {
        case .greek:
            return "Greek"
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        case .italian:
            return "Italian"
        case .german:
            return "German"
        }
    }

    init?(caseName: String) {
        for key in Language.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}

enum Accommodation: String, CaseIterable, Codable {
    case privateRoom
    case sharedRoom
    case dorm
    case tent

    var value: String {
        switch self {
        case .privateRoom:
            return "Private room"
        case .sharedRoom:
            return "Shared room"
        case .dorm:
            return "Dorm"
        case .tent:
            return "Tent"
        }
    }

    init?(caseName: String) {
        for key in Accommodation.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}

enum OpportunityCategory: String, CaseIterable, Codable {
    case hostel
    case hotel
    case guestHouse
    case farm
    case ecoVillage
    case skiCenter
    case camping
    case ngo
    case localCommunity
    case animalShelter
    case surfClub
    case winery
    case boat
    case homeStay
    case individual
    case privateProject

    var value: String {
        switch self {
        case .hostel:
            return "Hostel"
        case .hotel:
            return "Hotel"
        case .guestHouse:
            return "Guest House"
        case .farm:
            return "Farm"
        case .ecoVillage:
            return "Eco Village"
        case .skiCenter:
            return "Ski Center"
        case .camping:
            return "Camping"
        case .ngo:
            return "NGO"
        case .localCommunity:
            return "Local Community"
        case .animalShelter:
            return "Animal Shelter"
        case .surfClub:
            return "Surf Club"
        case .winery:
            return "Winery"
        case .boat:
            return "Boat"
        case .homeStay:
            return "Home Stay"
        case .individual:
            return "Individual"
        case .privateProject:
            return "Private project"
        }
    }

    init?(caseName: String) {
        for key in OpportunityCategory.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}

enum TypeOfHelp: String, CaseIterable, Codable {
    case reception
    case cleaning
    case houseKeeping
    case administrativeTasks
    case tourGuide
    case babysitter
    case vet
    case animalCare
    case languages
    case sportsTeacher
    case surfing
    case personalTrainer
    case farming
    case painting
    case handyman
    case socialMedia
    case photography
    case videography
    case webDevelopment
    case cooking
    case bartending
    case service

    var value: String {
        switch self {
        case .reception:
            return "Reception"
        case .cleaning:
            return "Cleaning"
        case .houseKeeping:
            return "House Keeping"
        case .administrativeTasks:
            return "Administrative tasks"
        case .tourGuide:
            return "Tour guide"
        case .babysitter:
            return "Babysitter"
        case .vet:
            return "Vet"
        case .animalCare:
            return "Animal care"
        case .languages:
            return "Languages"
        case .sportsTeacher:
            return "Sports teacher"
        case .surfing:
            return "Surfing"
        case .personalTrainer:
            return "Personal Trainer"
        case .farming:
            return "Farming"
        case .painting:
            return "Painting"
        case .handyman:
            return "Handyman"
        case .socialMedia:
            return "Social media"
        case .photography:
            return "Photography"
        case .videography:
            return "Videography"
        case .webDevelopment:
            return "Web development"
        case .cooking:
            return "Cooking"
        case .bartending:
            return "Bartending"
        case .service:
            return "Service"
        }
    }

    init?(caseName: String) {
        for key in TypeOfHelp.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}

enum LearningOpportunities: String, CaseIterable, Codable {
    case hospitality
    case languages
    case animalWelfare
    case volunteering
    case cultureExchange
    case charityWork
    case farming
    case photography
    case videography
    case technology
    case nonProfit
    case art
    case waterSports
    case nature
    case writing
    case yoga
    case fitness
    case dancing
    case gardening
    case cycling
    case books
    case babysitting
    case cooking
    case computers
    case programming
    case selfDevelopment
    case sustainability
    case hitchhiking
    case sailing
    case music
    case movies
    case fashion
    case history
    case architecture

    var value: String {
        switch self {
        case .hospitality:
            return "Hospitality"
        case .languages:
            return "Languages"
        case .animalWelfare:
            return "Animal welfare"
        case .volunteering:
            return "Volunteering"
        case .cultureExchange:
            return "Culture exchange"
        case .charityWork:
            return "Charity work"
        case .farming:
            return "Farming"
        case .photography:
            return "Photography"
        case .videography:
            return "Videography"
        case .technology:
            return "Technology"
        case .nonProfit:
            return "Non profit"
        case .art:
            return "Art"
        case .waterSports:
            return "Watersports"
        case .nature:
            return "Nature"
        case .writing:
            return "Writing"
        case .yoga:
            return "Yoga"
        case .fitness:
            return "Fitness"
        case .dancing:
            return "Dancing"
        case .gardening:
            return "Gardening"
        case .cycling:
            return "Cycling"
        case .books:
            return "Books"
        case .babysitting:
            return "Babysitting"
        case .cooking:
            return "Cooking"
        case .computers:
            return "Computers"
        case .programming:
            return "Programming"
        case .selfDevelopment:
            return "Self development"
        case .sustainability:
            return "Sustainability"
        case .hitchhiking:
            return "Hitchhikig"
        case .sailing:
            return "Sailing"
        case .music:
            return "Music"
        case .movies:
            return "Movies"
        case .fashion:
            return "Fashion"
        case .history:
            return "History"
        case .architecture:
            return "Architecture"
        }
    }

    init?(caseName: String) {
        for key in LearningOpportunities.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
