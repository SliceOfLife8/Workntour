//
//  HostAdditionalOfferingsViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 27/1/23.
//

import Foundation

class HostAdditionalOfferingsViewModel: BaseViewModel {

    // MARK: - Properties

    var dataModel: DataModel

    // MARK: - Constructors/Destructors

    required init(dataModel: DataModel) {
        self.dataModel = dataModel
    }
}

// MARK: - DataModel
extension HostAdditionalOfferingsViewModel {

    class DataModel {

        // MARK: - Properties

        var languagesSpoken: [Language]
        let languagesDataSource: [Language]
        var additionalOfferings: [AdditionalOfferings]
        let offeringsDataSource: [AdditionalOfferings]
        var experiences: String?
        var dietary: SpecialDietary
        var coupleAccepted: Bool?
        var wifi: Bool?
        var smoking: Bool?
        var pets: Bool?

        // MARK: - Constructors/Destructors

        init(optionals: OpportunityOptionals?) {
            self.languagesSpoken = optionals?.languagesSpoken ?? []
            self.languagesDataSource = Language.allCases
            self.additionalOfferings = optionals?.additionalOfferings ?? []
            self.offeringsDataSource = AdditionalOfferings.allCases
            self.experiences = optionals?.experience
            self.dietary = optionals?.specialDietary ?? .NONE
            self.coupleAccepted = optionals?.coupleAccepted
            self.wifi = optionals?.wifi
            self.smoking = optionals?.smokingAllowed
            self.pets = optionals?.petsAllowed
        }

        // MARK: - Methods

        func convertToOpportunityOptionals() -> OpportunityOptionals {
            return OpportunityOptionals(
                additionalOfferings: additionalOfferings,
                languagesSpoken: languagesSpoken,
                experience: experiences,
                specialDietary: dietary,
                coupleAccepted: coupleAccepted,
                wifi: wifi,
                smokingAllowed: smoking,
                petsAllowed: pets)
        }
    }
}
