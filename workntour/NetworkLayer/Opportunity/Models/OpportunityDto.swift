//
//  OpportunityDto.swift
//  workntour
//
//  Created by Chris Petimezas on 2/7/22.
//

import Foundation

struct OpportunityDto: Hashable, Codable {
    let memberId: String?
    let opportunityId: String?
    let category: OpportunityCategory
    let images: [Data]?
    let imageUrls: [String]
    let title: String
    var description: String?
    let typeOfHelp: [TypeOfHelp]
    let location: OpportunityLocation
    let dates: [OpportunityDates]
    let minDays: Int
    let maxDays: Int
    let workingHours: Int
    var daysOff: Int
    let languagesRequired: [Language]
    let accommodation: Accommodation
    let meals: [Meal]
    let learningOpportunities: [LearningOpportunities]
    let optionals: OpportunityOptionals?

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
        case daysOff, languagesRequired
        case accommodation = "accommodationProvided"
        case meals, learningOpportunities
        case optionals
    }

    init(
        memberId: String?,
        opportunityId: String? = nil,
        category: OpportunityCategory,
        images: [Data],
        imagesUrl: [String],
        title: String,
        description: String?,
        typeOfHelp: [TypeOfHelp],
        location: OpportunityLocation,
        dates: [OpportunityDates],
        minDays: Int,
        maxDays: Int,
        workingHours: Int,
        daysOff: Int,
        languagesRequired: [Language],
        accommodation: Accommodation,
        meals: [Meal],
        learningOpportunities: [LearningOpportunities],
        optionals: OpportunityOptionals?
    ) {
        self.memberId = memberId
        self.opportunityId = opportunityId
        self.category = category
        self.images = []
        self.imageUrls = imagesUrl
        self.title = title
        self.description = description
        self.typeOfHelp = typeOfHelp
        self.location = location
        self.dates = dates
        self.minDays = minDays
        self.maxDays = maxDays
        self.workingHours = workingHours
        self.daysOff = daysOff
        self.languagesRequired = languagesRequired
        self.accommodation = accommodation
        self.meals = meals
        self.learningOpportunities = learningOpportunities
        self.optionals = optionals
    }
}

struct OpportunityDates: Hashable, Codable {
    let start: String?
    let end: String?

    enum CodingKeys: String, CodingKey {
        case start = "startDate"
        case end = "endDate"
    }

    func convertToDates() -> CalendarDate? {
        guard let startDate = start?.asDate(),
              let endDate = end?.asDate()
        else {
            return nil
        }

        return CalendarDate(start: startDate, end: endDate)
    }
}

struct OpportunityLocation: Hashable, Codable {
    let placemark: PlacemarkAttributes?
    let latitude: Double
    let longitude: Double
}
