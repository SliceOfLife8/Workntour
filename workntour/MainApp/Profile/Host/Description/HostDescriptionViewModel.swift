//
//  HostDescriptionViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 1/12/22.
//

import Foundation

class HostDescriptionViewModel: BaseViewModel {
    /// Outputs
    var data: DataModel

    required init(data: DataModel) {
        self.data = data
    }
}

// MARK: - HostDescriptionViewModel.DataModel
extension HostDescriptionViewModel {

    class DataModel {

        // MARK: - Properties

        let navigationBarTitle: String
        let description: String?
        let link: String?
        let placeholder: String
        let charsLimit: Int

        // MARK: - Constructors/Destructors

        init(
            navigationBarTitle: String,
            description: String?,
            link: String?,
            placeholder: String,
            charsLimit: Int
        ) {
            self.navigationBarTitle = navigationBarTitle
            self.description = description
            self.link = link
            self.placeholder = placeholder
            self.charsLimit = charsLimit
        }
    }
}
