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

}

// MARK: - ProfileExperienceViewModel.DataModel
extension ProfileExperienceViewModel {

    class DataModel {

        // MARK: - Properties

        var experience: ProfileExperience

        // MARK: - Constructors/Destructors
        init(experience: ProfileExperience?) {
            self.experience = experience ?? ProfileExperience(type: .professional)
        }
    }
}
