//
//  Opportunity.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 21/6/22.
//

import Foundation

struct Opportunity: Hashable {
    let category: OpportunityCategory
    let images: [URL] // min 3, max 7
    let jobTitle: String // Required
    let jobDescription: String? // Optional
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
    let additionalOfferings: [String]?
    let learningOpportunities: [LearningOpportunities]
    let adventuresOffered: String?
    let wifi: Bool
    let smokingAllowed: Bool
    let petsAllowed: Bool
}

enum OpportunityCategory: String, CaseIterable {
    case hostel = "Hostel"
    case hotel = "Hotel"
    case guestHouse = "Guest House"
    case farm = "Farm"
    case ecoVillage = "Eco Village"
    case skiCenter = "Ski Center"
    case camping = "Camping"
    case ngo = "NGO"
    case localCommunity = "Local Community"
    case animalShelter = "Animal Shelter"
    case surfClub = "Surf Club"
    case winery = "Winery"
    case boat = "Boat"
    case homeStay = "Home Stay"
    case individual = "Individual"
    case privateProject = "Private project"
}

enum TypeOfHelp: String, CaseIterable {
    case reception = "Reception"
    case cleaning = "Cleaning"
    case houseKeeping = "House Keeping"
    case administrativeTasks = "Administrative tasks"
    case tourGuide = "Tour guide"
    case babysitter = "Babysitter"
    case vet = "Vet"
    case animalCare = "Animal care"
    case languages = "Languages"
    case sportsTeacher = "Sports teacher"
    case surfing = "Surfing"
    case personalTrainer = "Personal Trainer"
    case farming = "Farming"
    case painting = "Painting"
    case handyman = "Handyman"
    case socialMedia = "Social media"
    case photography = "Photography"
    case videography = "Videography"
    case webDevelopment = "Web development"
    case cooking = "Cooking"
    case bartending = "Bartending"
    case service = "Service"
}

struct OpportunityDates: Hashable {
    let start: String
    let end: String
}

struct OpportunityLocation: Hashable {
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
