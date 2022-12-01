//
//  ProfileExperienceViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 13/11/22.
//

import Foundation

class ProfileExperienceViewModel: BaseViewModel {
    /// Service
    private var service: ProfileService
    /// Inputs
    var traveler: TravelerProfileDto?

    /// Outputs
    var data: DataModel

    // MARK: - Init

    required init(data: DataModel, service: ProfileService = DataManager.shared) {
        self.data = data
        self.service = service
        self.traveler = UserDataManager.shared.retrieve(TravelerProfileDto.self)
    }

}

// MARK: - ProfileExperienceViewModel.DataModel
extension ProfileExperienceViewModel {

    class DataModel {

        enum Mode {
            case add
            case edit
        }

        // MARK: - Properties

        var experience: Experience
        let uuid: String
        let mode: Mode

        // MARK: - Constructors/Destructors

        init(experience: ProfileExperience? = nil) {
            self.mode = (experience == nil) ? .add : .edit
            self.uuid = experience?.uuid ?? UUID().uuidString
            self.experience = experience?.experience ?? Experience(type: .COMPANY)
        }

        // MARK: - Methods

        func convertToExperience() -> ProfileExperience {
            return .init(
                uuid: uuid,
                experience: experience
            )
        }
    }
}
