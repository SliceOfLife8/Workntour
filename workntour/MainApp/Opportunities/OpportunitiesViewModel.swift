//
//  OpportunitiesViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import Foundation

class OpportunitiesViewModel: BaseViewModel {
    /// Service
    private var service: AuthorizationService

    /// Inputs
    @Published var data: [Opportunity] = []

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service

        super.init()
    }

    func fetchModels() {
        guard let hotelURL = URL(string: "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60"),
              let wineryURL = URL(string: "https://images.unsplash.com/photo-1504279577054-acfeccf8fc52?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80"),
              let farmURL = URL(string: "https://images.unsplash.com/photo-1520190282873-afe1285c9a2a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2406&q=80"),
              let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()),
              let twoMonthsBefore = Calendar.current.date(byAdding: .month, value: -2, to: Date()),
              let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: Date()),
              let threeDaysBefore = Calendar.current.date(byAdding: .day, value: -3, to: Date())
        else {
            return
        }
        // swiftlint:disable line_length
        let models: [Opportunity] = [
            Opportunity(category: .hotel, images: [hotelURL], jobTitle: "Help us at our hotel and experience the Greek Lifestyle in the island of Crete.", jobDescription: nil, typeOfHelpNeeded: [.service], location: .init(title: "Crete, Greece", latitude: 32.0, longitude: 33.0), dates: [OpportunityDates(start: previousMonth, end: dayBefore)], minimumDays: 7, maximumDays: 20, totalWorkingHours: 25, daysOff: 1, languagesRequired: [.english], languagesSpoken: nil, accommondationProvided: .privateRoom, meals: [.lunch], additionalOfferings: nil, learningOpportunities: [.cooking], adventuresOffered: nil, wifi: true, smokingAllowed: false, petsAllowed: false),
            Opportunity(category: .winery, images: [wineryURL], jobTitle: "We believe that a good wine has its roots in the vineyard from the healthy and natural vines.", jobDescription: nil, typeOfHelpNeeded: [.service], location: .init(title: "Nemea, Corinth, Greece", latitude: 32.0, longitude: 33.0), dates: [OpportunityDates(start: twoMonthsBefore, end: threeDaysBefore), OpportunityDates(start: previousMonth, end: dayBefore), OpportunityDates(start: previousMonth, end: dayBefore), OpportunityDates(start: previousMonth, end: dayBefore)], minimumDays: 7, maximumDays: 20, totalWorkingHours: 25, daysOff: 1, languagesRequired: [.english], languagesSpoken: nil, accommondationProvided: .privateRoom, meals: [.lunch], additionalOfferings: nil, learningOpportunities: [.cooking], adventuresOffered: nil, wifi: true, smokingAllowed: false, petsAllowed: false),
            Opportunity(category: .farm, images: [farmURL], jobTitle: "We are a busy couple with grown children, but with a big family around! On our farm, at the moment we have 12 huskies, 3 horses (two of them shetties), 2 rabbits, 3 cats and 13 alpacas.", jobDescription: nil, typeOfHelpNeeded: [.animalCare], location: .init(title: "Flagstad, Norway", latitude: 32.0, longitude: 33.0), dates: [OpportunityDates(start: twoMonthsBefore, end: threeDaysBefore)], minimumDays: 7, maximumDays: 20, totalWorkingHours: 25, daysOff: 1, languagesRequired: [.english], languagesSpoken: nil, accommondationProvided: .privateRoom, meals: [.breakfast], additionalOfferings: nil, learningOpportunities: [.animalWelfare], adventuresOffered: nil, wifi: true, smokingAllowed: false, petsAllowed: false),
        ]

        data = models
    }
}
