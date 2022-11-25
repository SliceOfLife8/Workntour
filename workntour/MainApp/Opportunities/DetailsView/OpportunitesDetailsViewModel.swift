//
//  OpportunitesDetailsViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 4/7/22.
//

import Foundation
import Combine

/*
 5. Map
 12. Do workntour (for travellers only!)
 */

class OpportunitesDetailsViewModel: BaseViewModel {
    /// Service
    private var service: OpportunityService

    /// Outputs
    @Published var images: [URL] = []
    var headerModel: OpportunityDetailsHeaderModel?
    @Published var data: [OpportunityDetailsModel] = []
    @Published var errorMessage: String?
    @Published var opportunityWasDeleted: Bool = false
    var opportunityDates: OpportunityDates?

    init(service: OpportunityService = DataManager.shared) {
        self.service = service

        super.init()
    }

    func fetchModels(opportunityId: String) {
        loaderVisibility = true
        service.getOpportunity(byId: opportunityId)
            .subscribe(on: RunLoop.main)
            .map({ output in
                self.images = output.imageUrls.compactMap { URL(string: $0) }
                // Show address depending on user role
                self.headerModel = OpportunityDetailsHeaderModel(title: output.title,
                                                                 area: output.location.placemark?.formattedName(userIsHost: UserDataManager.shared.role?.oneOf(other: .COMPANY_HOST, .INDIVIDUAL_HOST)),
                                                                 category: output.category)

                var models = [
                    OpportunityDetailsModel(title: "Type of help needed", description: output.typeOfHelp.map { $0.value }.joined(separator: ", ")),
                    OpportunityDetailsModel(title: "Accomondation provided", description: output.accommodation.value),
                    OpportunityDetailsModel(title: "Meals provided", description: output.meals.map { $0.value }.joined(separator: ", ")),
                    OpportunityDetailsModel(title: String(output.minDays), description: String(output.maxDays), showDays: true),
                    OpportunityDetailsModel(location: output.location),
                    OpportunityDetailsModel(title: "Languages required", description: output.languagesRequired.map { $0.value }.joined(separator: ", ")),
                    OpportunityDetailsModel(title: "Languages spoken", description: output.languagesSpoken?.compactMap { $0.value }.joined(separator: ", ")),
                    OpportunityDetailsModel(title: "Learning Opportunities", description: output.learningOpportunities.map { $0.value }.joined(separator: ", ")),
                    OpportunityDetailsModel(title: output.dates.first?.start, description: output.dates.first?.end, dates: true)
                ]

                if let description = output.description {
                    models.append(OpportunityDetailsModel(title: "Description", description: description))
                }

                self.opportunityDates = output.dates.first

                return models
            })
            .catch({ [weak self] error -> Just<[OpportunityDetailsModel]> in
                self?.errorMessage = error.errorDescription

                return Just([])
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$data)
    }

    func deleteOpportunity(opportunityId: String) {
        loaderVisibility = true
        service.deleteOpportunity(byId: opportunityId)
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$opportunityWasDeleted)
    }
}
