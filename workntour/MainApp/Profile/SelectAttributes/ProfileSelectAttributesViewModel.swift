//
//  ProfileSelectAttributesViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 12/11/22.
//

import Networking
import Combine

class ProfileSelectAttributesViewModel: BaseViewModel {
    /// Inputs
    @Published var traveler: TravelerProfileDto?

    /// Outputs
    var data: DataModel
    @Published var updateProfileDto: TravelerProfileDto?

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
        self.traveler = UserDataManager.shared.retrieve(TravelerProfileDto.self)
    }

    func updateInfo() {
        guard var travelerDto = traveler else { return }

        switch data.mode {
        case .skills:
            print("add case")
        case .interests:
            print("add case")
        case .travelerType:
            travelerDto.type = data.convertAttributesToTypeOfTraveler()
        }

        self.updateProfileDto = travelerDto
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
            case travelerType
        }

        // MARK: - Properties

        let navigationBarTitle: String
        let mode: Mode
        let headerTitle: String
        let description: String
        let minItemsToBeSelected: Int
        var attributes: [ProfileAttribute]
        let allowMultipleSelection: Bool

        // MARK: - Constructors/Destructors

        init(
            navigationBarTitle: String,
            mode: Mode,
            headerTitle: String,
            description: String,
            minItemsToBeSelected: Int,
            attributes: [ProfileAttribute],
            allowMultipleSelection: Bool = true
        ) {
            self.navigationBarTitle = navigationBarTitle
            self.mode = mode
            self.headerTitle = headerTitle
            self.description = description
            self.minItemsToBeSelected = minItemsToBeSelected
            self.attributes = attributes
            self.allowMultipleSelection = allowMultipleSelection
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

        func convertAttributesToTypeOfTraveler() -> TravelerType? {
            return attributes
                .filter { $0.isSelected }
                .compactMap { TravelerType(caseName: $0.title) }
                .first
        }
    }
}
