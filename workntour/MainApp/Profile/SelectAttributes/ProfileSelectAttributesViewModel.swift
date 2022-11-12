//
//  ProfileSelectAttributesViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 12/11/22.
//

import Networking
import Combine

class ProfileSelectAttributesViewModel: BaseViewModel {
    /// Service
    private var service: ProfileService
    /// Inputs
    @Published var traveler: TravelerProfile?

    /// Outputs
    var data: DataModel
    @Published var profileUpdated: Bool = false

    // MARK: - Init

    required init(data: DataModel, service: ProfileService = DataManager.shared) {
        self.data = data
        self.service = service
        self.traveler = UserDataManager.shared.retrieve(TravelerProfile.self)
    }

    func updateTravelerProfile() {
        guard let travelerModel = traveler else {
            return
        }

        switch data.mode {
        case .skills:
            print("update dataModel skills: \(data.convertAttributesToSkills())")
            return
        case .interests:
            print("update dataModel interests \(data.convertAttributesToSkills())")
        }

        loaderVisibility = true
        service.updateTravelerProfile(model: travelerModel)
            .map { $0 != nil }
            .subscribe(on: RunLoop.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.loaderVisibility = false
                })
                    .assign(to: &$profileUpdated)
    }

}

// MARK: - ProfileSelectAttributesViewModel.DataModel
extension ProfileSelectAttributesViewModel {

    class ProfileAttribute {
        let title: String
        var isSelected: Bool

        init(title: String, isSelected: Bool) {
            self.title = title
            self.isSelected = isSelected
        }

        func updateAttribute(_ selected: Bool) {
            self.isSelected = selected
        }
    }

    class DataModel {

        enum Mode {
            case skills
            case interests
        }

        // MARK: - Properties

        let navigationBarTitle: String
        let mode: Mode
        let headerTitle: String
        let description: String
        let minItemsToBeSelected: Int
        var attributes: [ProfileAttribute]

        // MARK: - Constructors/Destructors

        init(
            navigationBarTitle: String,
            mode: Mode,
            headerTitle: String,
            description: String,
            minItemsToBeSelected: Int,
            attributes: [ProfileAttribute]
        ) {
            self.navigationBarTitle = navigationBarTitle
            self.mode = mode
            self.headerTitle = headerTitle
            self.description = description
            self.minItemsToBeSelected = minItemsToBeSelected
            self.attributes = attributes
        }

        // MARK: - Methods

        func convertAttributesToSkills() -> [TypeOfHelp] {
            return attributes
                .filter { $0.isSelected }
                .compactMap { TypeOfHelp(caseName: $0.title) }
        }

        func convertAttributesToInterests() -> [LearningOpportunities] {
            return attributes
                .filter { $0.isSelected }
                .compactMap { LearningOpportunities(caseName: $0.title) }
        }
    }
}
