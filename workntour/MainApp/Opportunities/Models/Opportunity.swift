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
    let daysOff: Int? // Per week from 1-5
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

enum Language: String, CaseIterable {
    case greek = "Greek"
    case english = "English"
    case spanish = "Spanish"
    case italian = "Italian"
    case german = "German"
}

enum Accommodation: String, CaseIterable {
    case privateRoom = "Private room"
    case sharedRoom = "Shared room"
    case dorm = "Dorm"
    case tent = "Tent"
}

enum Meal {
    case breakfast
    case lunch
    case dinner
    case useSharedKitchen
}

enum LearningOpportunities: String, CaseIterable {
    case hospitality = "Hospitality"
    case languages = "Languages"
    case animalWelfare = "Animal welfare"
    case volunteering = "Volunteering"
    case cultureExchange = "Culture exchange"
    case charityWork = "Charity work"
    case farming = "Farming"
    case photography = "Photography"
    case videography = "Videography"
    case technology = "Technology"
    case non_profit = "Non profit"
    case art = "Art"
    case watersports = "Watersports"
    case nature = "Nature"
    case writing = "Writing"
    case yoga = "Yoga"
    case fitness = "Fitness"
    case dancing = "Dancing"
    case gardening = "Gardening"
    case cycling = "Cycling"
    case books = "Books"
    case babysitting = "Babysitting"
    case cooking = "Cooking"
    case computers = "Computers"
    case programming = "Programming"
    case self_development = "Self development"
    case sustainability = "Sustainability"
    case hitchhiking = "Hitchhikig"
    case sailing = "Sailing"
    case music = "Music"
    case movies = "Movies"
    case fashion = "Fashion"
    case history = "History"
    case architecture = "Architecture"
}
