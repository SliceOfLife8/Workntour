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
    var companyHost: CompanyHostProfileDto?
    var individualHost: IndividualHostProfileDto?

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

    func updateProfile(
        _ incomingProfileDto: CompanyHostProfileDto? = nil,
        withMedia media: Media? = nil
    ) {
        guard let companyHost else { return }
        let profileDto = incomingProfileDto ?? companyHost

        loaderVisibility = true
        let updatedBody = CompanyUpdatedBody(updatedCompanyHostProfile: profileDto, media: media)

        MediaContext.updateCompanyHost(body: updatedBody).dataRequest(
            objectType: GenericResponse<CompanyHostProfileDto>.self,
            completion: { (result: Result) in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.profileUpdated = true
                        self.loaderVisibility = false
                    }
                    self.companyHost = profile.data
                    UserDataManager.shared.save(
                        profile.data,
                        memberId: profile.data?.memberID,
                        role: profile.data?.role
                    )
                case .failure:
                    DispatchQueue.main.async {
                        self.profileUpdated = false
                        self.loaderVisibility = false
                    }
                }
            })
    }

    func updateProfile(
        incomingProfileDto: IndividualHostProfileDto? = nil,
        media: Media? = nil
    ) {
        guard let individualHost else { return }
        let profileDto = incomingProfileDto ?? individualHost

        loaderVisibility = true
        let updatedBody = IndividualUpdatedBody(updatedIndividualHost: profileDto, media: media)

        MediaContext.updateIndividualHost(body: updatedBody).dataRequest(
            objectType: GenericResponse<IndividualHostProfileDto>.self,
            completion: { (result: Result) in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.profileUpdated = true
                        self.loaderVisibility = false
                    }
                    self.individualHost = profile.data
                    UserDataManager.shared.save(
                        profile.data,
                        memberId: profile.data?.memberID,
                        role: profile.data?.role
                    )
                case .failure:
                    DispatchQueue.main.async {
                        self.profileUpdated = false
                        self.loaderVisibility = false
                    }
                }
            })
    }

    func retrieveProfile() {
        guard let memberId = UserDataManager.shared.memberId else { return }
        
        if isCompany {
            service.getCompanyHostProfile(memberId: memberId)
                .subscribe(on: RunLoop.main)
                .catch({ _ -> Just<Bool> in
                    return Just(false)
                })
                    .handleEvents(receiveCompletion: { status in
                        self.loaderVisibility = false
                        self.profileUpdated = true
                        self.companyHost = UserDataManager.shared.retrieve(CompanyHostProfileDto.self)
                    })
                        .assign(to: &$getRefreshedProfile)
        }
        else {
            service.getIndividualHostProfile(memberId: memberId)
                .subscribe(on: RunLoop.main)
                .catch({ _ -> Just<Bool> in
                    return Just(false)
                })
                    .handleEvents(receiveCompletion: { _ in
                        self.loaderVisibility = false
                        self.profileUpdated = true
                        self.individualHost = UserDataManager.shared.retrieve(IndividualHostProfileDto.self)
                    })
                        .assign(to: &$getRefreshedProfile)
        }
    }

}

// MARK: - DataModels
extension HostProfileViewModel {

    var numberOfRows: Int {
        let cases = HostProfileSection.allCases.count
        return isCompany ? cases : cases - 1
    }

    func getHeaderDataModel() -> ProfileHeaderView.DataModel? {
        if let companyData = companyHost {
            let percents = companyData.percents

            return .init(
                mode: .company,
                profileUrl: companyData.getProfileImage(),
                fullname: companyData.name,
                introText: "host_intro".localized(),
                percent360: percents.percent360,
                percent100: percents.percent100,
                duration: percents.duration
            )
        }
        else if let individualData = individualHost {
            let percents = individualData.percents

            return .init(
                mode: .individual,
                profileUrl: individualData.getProfileImage(),
                fullname: individualData.fullname,
                introText: "host_intro".localized(),
                percent360: percents.percent360,
                percent100: percents.percent100,
                duration: percents.duration
            )
        }

        return nil
    }

    func getSimpleCellDataModel(_ index: Int) -> ProfileSimpleCell.DataModel? {
        var descriptionValue: String? = nil
        if let companyData = companyHost {
            descriptionValue = companyData.description
        }
        else if let individualData = individualHost {
            descriptionValue = individualData.description
        }

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
                values: [descriptionValue],
                placeholder: "host_description_placeholder".localized()
            )
        default:
            assertionFailure("Check collectionView's sizeForItem func.")
            return nil
        }
    }

    func getApdCellDataModel() -> AuthorizedPersonalDocumentCell.DataModel? {
        guard let companyHost else { return nil }

        return .init(
            title: "apd".localized(),
            docName: companyHost.getDocumentName()
        )
    }
}
