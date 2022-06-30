//
//  CreateOpportunityViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 27/6/22.
//

import Foundation
import UIKit

class CreateOpportunityViewModel: BaseViewModel {

    /// Inputs
    var category: OpportunityCategory? {
        didSet {
            updateProgressBar()
        }
    }
    var jobTitle: String = "" {
        didSet {
            updateProgressBar()
        }
    }
    var jobDescription: String?
    var typeOfHelp: [TypeOfHelp] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var location: OpportunityLocation? {
        didSet {
            updateProgressBar()
        }
    }
    var dates: [OpportunityDates] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var minDays: Int = 0 {
        didSet {
            updateProgressBar()
        }
    }
    var maxDays: Int = 0 {
        didSet {
            updateProgressBar()
        }
    }
    var totalHours: Int = 0 {
        didSet {
            updateProgressBar()
        }
    }
    var languagesRequired: [Language] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var languagesSpoken: [Language] = []
    var accommodation: Accommodation? {
        didSet {
            updateProgressBar()
        }
    }
    var meals: [Meal] = [] {
        didSet {
            updateProgressBar()
        }
    }
    var learningOpportunities: [LearningOpportunities] = [] {
        didSet {
            updateProgressBar()
        }
    }
    @Published var images: [UIImage] = []

    /// Outputs
    @Published var progress: Float = 0
    @Published var validData: Bool?

    // swiftlint:disable cyclomatic_complexity
    /// 13 Required fields in order to activate `Create` button
    func updateProgressBar() {
        var percent: Float = 0

        if category != nil { percent += 1/13 }
        if !jobTitle.isEmpty { percent += 1/13 }
        if images.count > 0 { percent += 1/13 }
        if typeOfHelp.count > 0 { percent += 1/13 }
        if location != nil { percent += 1/13 }
        if dates.count > 0 { percent += 1/13 }
        if minDays > 0 { percent += 1/13 }
        if maxDays > 0 { percent += 1/13 }
        if (1...32).contains(totalHours) { percent += 1/13 }
        if languagesRequired.count > 0 { percent += 1/13 }
        if accommodation != nil { percent += 1/13 }
        if meals.count > 0 { percent += 1/13 }
        if learningOpportunities.count > 0 { percent += 1/13 }

        progress = percent
    }

    /// We should validate all required data here. This func should be called when `Create button` is `enabled`.
    func validateData() {
        guard let _category = category,
              let _location = location,
              let _accommodation = accommodation
        else {
            validData = false
            return
        }

        let data = images.compactMap { $0.pngData() }
        print("data: \(_category) \(_location) \(_accommodation) \(data)")
        validData = true
    }
}
