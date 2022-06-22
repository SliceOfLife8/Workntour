//
//  Opportunity.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 21/6/22.
//

import Foundation

struct Opportunity {
    let category: OpportunityCategory
    let images: [Data] // min 3, max 7
    let jobTitle: String
    let jobDescription: String?
    let typeOfHelpNeeded: [TypeOfHelp]
    let location: OpportunityLocation // TBD
    let dates: [OpportunityDates]
    let minimumDays: Int
    let maximumDays: Int
    let totalWorkingHours: Int // per week max 32
    let daysOff: Int // Per week from 1-5
    let languagesRequired: [Language]
    let languagesSpoken: [Language]?
    let accommondationProvided: Accommodation
    let meals: [Meal]
    let additionalOfferings: [String]
    let learningOpportunities: [LearningOpportunities]
    let adventuresOffered: String?
    let wifi: Bool
    let smokingAllowed: Bool
    let petsAllowed: Bool
}

enum OpportunityCategory {
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
}

enum TypeOfHelp {
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
}

struct OpportunityDates {
    let start: Date
    let end: Date
}

struct OpportunityLocation {
    let title: String
    let latitude: Double
    let longitude: Double
}

enum Language {
    case greek
    case english
    case spanish
    case italian
    case german
}

enum Accommodation {
    case privateRoom
    case sharedRoom
    case dorm
    case tent
}

enum Meal {
    case breakfast
    case lunch
    case dinner
    case useSharedKitchen
}

enum LearningOpportunities {
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
    case non_profit
    case art
    case watersports
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
    case self_development
    case sustainability
    case hitchhiking
    case sailing
    case music
    case movies
    case fashion
    case history
    case architecture
}
