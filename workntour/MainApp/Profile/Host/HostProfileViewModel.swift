//
//  HostProfileViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 19/6/22.
//

import Combine
import SharedKit
import CommonUI

class HostProfileViewModel: BaseViewModel {
    /// Service
    private var service: ProfileService
    /// Inputs
    var isCompany: Bool = false
    @Published var companyHost: CompanyHostProfileDto?
    @Published var individualHost: IndividualHostProfileDto?

    /// Outputs
    @Published var newImage: Media?
    @Published var profileUpdated: Bool = false
    @Published var getRefreshedProfile: Bool = false
    var shouldShowAnimation: Bool = true

    // MARK: - Init
    init(
        service: ProfileService = DataManager.shared,
         isHostCompany: Bool
    ) {
        self.service = service
        self.isCompany = isHostCompany
        self.companyHost = UserDataManager.shared.retrieve(CompanyHostProfileDto.self)
        self.individualHost = UserDataManager.shared.retrieve(IndividualHostProfileDto.self)

        super.init()
    }

}

// MARK: - DataModels
extension HostProfileViewModel { 

    func getHeaderDataModel() -> ProfileHeaderView.DataModel? {
        guard let data = companyHost else { return nil }
        let percents = data.percents

        return nil

//        return .init(
//            mode: .traveler,
//            profileUrl: data.getProfileImage(),
//            fullname: data.name,
//            introText: "traveler_intro".localized(),
//            percent360: percents.percent360,
//            percent100: percents.percent100,
//            duration: percents.duration
//        )
    }

    func getSimpleCellDataModel(_ index: Int) -> ProfileSimpleCell.DataModel? {
        guard let data = companyHost else { return nil }

        switch HostProfileSection(rawValue: index) {
        case .personalInfo:
            return .init(
                title: HostProfileSection.personalInfo.value,
                values: [],
                placeholder: "personal_info_placeholder".localized()
            )
        case .description:
            return .init(
                title: HostProfileSection.description.value,
                values: [data.description],
                placeholder: "description_placeholder".localized()
            )
        default:
            assertionFailure("Check collectionView's sizeForItem func.")
            return nil
        }
    }
}
