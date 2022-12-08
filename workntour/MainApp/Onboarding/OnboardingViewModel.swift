//
//  OnboardingViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 7/12/22.
//

import CommonUI

class OnboardingViewModel: BaseViewModel {

    let totalPages: Int = 3

    func getDataModel(_ index: Int) -> OnboardingCell.DataModel? {
        switch index {
        case 0:
            return .init(
                mode: .pageOne,
                title: "onboarding_page_one_title".localized(),
                description: "onboarding_page_one_description".localized()
            )
        case 1:
            return  .init(
                mode: .pageTwo,
                title: "onboarding_page_two_title".localized(),
                description: "onboarding_page_two_description".localized()
            )
        default:
            return  .init(
                mode: .pageThree,
                title: "onboarding_page_three_title".localized(),
                description: "onboarding_page_three_description".localized()
            )
        }
    }
}
