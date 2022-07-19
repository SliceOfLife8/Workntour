//
//  OpportunityFilterDto.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 13/7/22.
//

import Foundation

struct OpportunityFilterDto: Codable {
    var category: OpportunityCategory?
    var typeOfHelp: [TypeOfHelp]
    var minDays: Int?
    var maxDays: Int?
    var languagesRequired: [Language]
    var accommodation: Accommodation?
    var meals: [Meal]
    var longitude: Double?
    var latitude: Double?
    var startDate: String?
    var endDate: String?

    enum CodingKeys: String, CodingKey {
        case category = "opportunityCategory"
        case typeOfHelp = "typeOfHelpNeeded"
        case minDays = "minimumDays"
        case maxDays = "maximumDays"
        case accommodation = "accommodationProvided"
        case languagesRequired, meals
        case longitude, latitude, startDate, endDate
    }

    init(category: OpportunityCategory? = nil, typeOfHelp: [TypeOfHelp] = [], minDays: Int? = nil, maxDays: Int? = nil,
         languagesRequired: [Language] = [], accommodation: Accommodation? = nil, meals: [Meal] = [], longitude: Double? = nil,
         latitude: Double? = nil, startDate: String? = nil, endDate: String? = nil) {
        self.category = category
        self.typeOfHelp = typeOfHelp
        self.minDays = minDays
        self.maxDays = maxDays
        self.languagesRequired = languagesRequired
        self.accommodation = accommodation
        self.meals = meals
        self.longitude = longitude
        self.latitude = latitude
        self.startDate = startDate
        self.endDate = endDate
    }

    var isEmpty: Bool {
        return category == nil && typeOfHelp.count == 0 && minDays == nil && maxDays == nil &&
        languagesRequired.count == 0 && accommodation == nil && meals.count == 0 &&
        longitude == nil && latitude == nil && startDate == nil && endDate == nil
    }

    var basicFiltersAreEmpty: Bool {
        return category == nil && typeOfHelp.count == 0 && minDays == nil && maxDays == nil &&
        languagesRequired.count == 0 && accommodation == nil && meals.count == 0
        && startDate == nil && endDate == nil
    }

    var areaIsFilled: Bool {
        return longitude != nil && latitude != nil
    }

    mutating func addArea(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }

    mutating func addDays(min: Int, max: Int) {
        self.minDays = min
        self.maxDays = max
    }

    mutating func addDates(start: String, end: String) {
        self.startDate = start
        self.endDate = end
    }

    mutating func resetFilters() {
        self.category = nil
        self.typeOfHelp.removeAll()
        self.minDays = nil
        self.maxDays = nil
        self.languagesRequired.removeAll()
        self.accommodation = nil
        self.meals.removeAll()
        self.startDate = nil
        self.endDate = nil
    }

    mutating func resetArea() {
        self.longitude = nil
        self.latitude = nil
    }
}
