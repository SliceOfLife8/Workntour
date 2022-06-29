//
//  CreateOpportunityViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 27/6/22.
//

import Foundation
import UIKit
/*
 Required Fields
 7. MinDays
 8. MaxDays
 9. TotalHours
 10. DaysOff
 11. LanguagesRequired
 12. Accommodation
 13. Meals
 14. LearningOpportunities
 */

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
    @Published var images: [UIImage] = []

    /// Outputs
    @Published var progress: Float = 0

    func updateProgressBar() {
        var percent: Float = 0

        if category != nil { percent += 1/14 }
        if !jobTitle.isEmpty { percent += 1/14 }
        if images.count > 0 { percent += 1/14 }
        if typeOfHelp.count > 0 { percent += 1/14 }
        if location != nil { percent += 1/14 }
        if dates.count > 0 { percent += 1/14 }

        progress = percent
    }
}
