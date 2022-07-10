//
//  OpportunityDto.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 2/7/22.
//

import Foundation

struct OpportunityDto: Hashable, Codable {
    let memberId: String?
    let opportunityId: String?
    let category: OpportunityCategory
    let images: [Data]
    let imageUrls: [String]
    let title: String
    var description: String?
    let typeOfHelp: [TypeOfHelp]
    let location: OpportunityLocation
    let dates: [OpportunityDates]
    let minDays: Int
    let maxDays: Int
    let workingHours: Int
    var daysOff: Int?
    let languagesRequired: [Language]
    let languagesSpoken: [Language]?
    let accommodation: Accommodation
    let meals: [Meal]
    var additionalOfferings: [String]?
    let learningOpportunities: [LearningOpportunities]
    var adventuresOffered: String?
    var wifi: Bool?
    var smoking: Bool?
    var pets: Bool?

    enum CodingKeys: String, CodingKey {
        case memberId, opportunityId
        case category = "opportunityCategory"
        case images, imageUrls
        case dates = "opportunityDates"
        case title = "jobTitle"
        case description = "jobDescription"
        case typeOfHelp = "typeOfHelpNeeded"
        case location = "opportunityLocation"
        case minDays = "minimumDays"
        case maxDays = "maximumDays"
        case workingHours = "totalWorkingHours"
        case daysOff, languagesRequired, languagesSpoken
        case accommodation = "accommodationProvided"
        case meals, additionalOfferings, learningOpportunities
        case adventuresOffered, wifi
        case smoking = "smokingAllowed"
        case pets = "petsAllowed"
    }

    init(memberId: String?, opportunityId: String? = nil, category: OpportunityCategory, images: [Data], title: String, description: String?, typeOfHelp: [TypeOfHelp],
         location: OpportunityLocation, dates: [OpportunityDates], minDays: Int, maxDays: Int, workingHours: Int,
         languagesRequired: [Language], languagesSpoken: [Language]?, accommodation: Accommodation, meals: [Meal],
         learningOpportunities: [LearningOpportunities]) {
        self.memberId = memberId
        self.opportunityId = opportunityId
        self.category = category
        self.images = images
        self.imageUrls = []
        self.title = title
        self.description = description
        self.typeOfHelp = typeOfHelp
        self.location = location
        self.dates = dates
        self.minDays = minDays
        self.maxDays = maxDays
        self.workingHours = workingHours
        self.languagesRequired = languagesRequired
        self.languagesSpoken = languagesSpoken
        self.accommodation = accommodation
        self.meals = meals
        self.learningOpportunities = learningOpportunities
    }
}

struct OpportunityDates: Hashable, Codable {
    let start: String
    let end: String

    enum CodingKeys: String, CodingKey {
        case start = "startDate"
        case end = "endDate"
    }
}

struct OpportunityLocation: Hashable, Codable {
    let placemark: PlacemarkAttributes?
    let latitude: Double
    let longitude: Double
}
