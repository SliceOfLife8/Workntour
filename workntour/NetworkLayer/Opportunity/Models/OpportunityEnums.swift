//
//  OpportunityEnums.swift
//  workntour
//
//  Created by Chris Petimezas on 5/7/22.
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
    case RECEPTION
    case CLEANING
    case HOUSE_KEEPING
    case ADMINISTRATIVE_TASKS
    case TOUR_GUIDE
    case BABYSITTER
    case VET
    case ANIMAL_CARE
    case LANGUAGES
    case SPORTS_TEACHER
    case SURFING
    case PERSONAL_TRAINER
    case FARMING
    case PAINTING
    case HANDYMAN
    case SOCIAL_MEDIA
    case PHOTOGRAPHY
    case VIDEOGRAPHY
    case WEB_DEVELOPMENT
    case COOKING
    case BARTENDING
    case SERVICE

    var value: String {
        switch self {
        case .RECEPTION:
            return "Reception"
        case .CLEANING:
            return "Cleaning"
        case .HOUSE_KEEPING:
            return "House Keeping"
        case .ADMINISTRATIVE_TASKS:
            return "Administrative tasks"
        case .TOUR_GUIDE:
            return "Tour guide"
        case .BABYSITTER:
            return "Babysitter"
        case .VET:
            return "Vet"
        case .ANIMAL_CARE:
            return "Animal care"
        case .LANGUAGES:
            return "Languages"
        case .SPORTS_TEACHER:
            return "Sports teacher"
        case .SURFING:
            return "Surfing"
        case .PERSONAL_TRAINER:
            return "Personal Trainer"
        case .FARMING:
            return "Farming"
        case .PAINTING:
            return "Painting"
        case .HANDYMAN:
            return "Handyman"
        case .SOCIAL_MEDIA:
            return "Social media"
        case .PHOTOGRAPHY:
            return "Photography"
        case .VIDEOGRAPHY:
            return "Videography"
        case .WEB_DEVELOPMENT:
            return "Web development"
        case .COOKING:
            return "Cooking"
        case .BARTENDING:
            return "Bartending"
        case .SERVICE:
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
    case HOSPITALITY
    case LANGUAGES
    case ANIMAL_WELFARE
    case VOLUNTEERING
    case CULTURE_EXCHANGE
    case CHARITY_WORK
    case FARMING
    case PHOTOGRAPHY
    case VIDEOGRAPHY
    case TECHNOLOGY
    case NON_PROFIT
    case ART
    case WATER_SPORTS
    case NATURE
    case WRITING
    case YOGA
    case FITNESS
    case DANCING
    case GARDENING
    case CYCLING
    case BOOKS
    case BABYSITTING
    case COOKING
    case COMPUTERS
    case PROGRAMMING
    case SELF_DEVELOPMENT
    case SUSTAINABILITY
    case HITCHHIKING
    case SAILING
    case MUSIC
    case MOVIES
    case FASHION
    case HISTORY
    case ARCHITECTURE

    var value: String {
        switch self {
        case .HOSPITALITY:
            return "Hospitality"
        case .LANGUAGES:
            return "Languages"
        case .ANIMAL_WELFARE:
            return "Animal welfare"
        case .VOLUNTEERING:
            return "Volunteering"
        case .CULTURE_EXCHANGE:
            return "Culture exchange"
        case .CHARITY_WORK:
            return "Charity work"
        case .FARMING:
            return "Farming"
        case .PHOTOGRAPHY:
            return "Photography"
        case .VIDEOGRAPHY:
            return "Videography"
        case .TECHNOLOGY:
            return "Technology"
        case .NON_PROFIT:
            return "Non profit"
        case .ART:
            return "Art"
        case .WATER_SPORTS:
            return "Watersports"
        case .NATURE:
            return "Nature"
        case .WRITING:
            return "Writing"
        case .YOGA:
            return "Yoga"
        case .FITNESS:
            return "Fitness"
        case .DANCING:
            return "Dancing"
        case .GARDENING:
            return "Gardening"
        case .CYCLING:
            return "Cycling"
        case .BOOKS:
            return "Books"
        case .BABYSITTING:
            return "Babysitting"
        case .COOKING:
            return "Cooking"
        case .COMPUTERS:
            return "Computers"
        case .PROGRAMMING:
            return "Programming"
        case .SELF_DEVELOPMENT:
            return "Self development"
        case .SUSTAINABILITY:
            return "Sustainability"
        case .HITCHHIKING:
            return "Hitchhikig"
        case .SAILING:
            return "Sailing"
        case .MUSIC:
            return "Music"
        case .MOVIES:
            return "Movies"
        case .FASHION:
            return "Fashion"
        case .HISTORY:
            return "History"
        case .ARCHITECTURE:
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

enum LanguageProficiency: Int, CaseIterable, Codable {
    case BEGINNER = 0
    case INTERMEDIATE = 1
    case FLUENT = 2

    var value: String {
        switch self {
        case .BEGINNER:
            return "Beginner"
        case .INTERMEDIATE:
            return "Intermediate"
        case .FLUENT:
            return "Fluent"
        }
    }

    init?(caseName: String) {
        for key in LanguageProficiency.allCases where "\(key.value)" == caseName {
            self = key
            return
        }

        return nil
    }
}
