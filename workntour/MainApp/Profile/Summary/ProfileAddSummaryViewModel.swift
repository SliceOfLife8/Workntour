//
//  ProfileAddSummaryViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 14/11/22.
//

import Foundation

class ProfileAddSummaryViewModel: BaseViewModel {
    /// Outputs
    var data: DataModel

    required init(data: DataModel) {
        self.data = data
    }
}

// MARK: - ProfileAddSummaryViewModel.DataModel
extension ProfileAddSummaryViewModel {

    class DataModel {

        // MARK: - Properties
        let navigationBarTitle: String
        let description: String?
        let placeholder: String
        let charsLimit: Int

        // MARK: - Constructors/Destructors

        init(
            navigationBarTitle: String,
            description: String?,
            placeholder: String,
            charsLimit: Int
        ) {
            self.navigationBarTitle = navigationBarTitle
            self.description = description
            self.placeholder = placeholder
            self.charsLimit = charsLimit
        }
    }
}
