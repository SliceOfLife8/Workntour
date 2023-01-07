//
//  LinkExpiredViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 5/1/23.
//

import Foundation

class LinkExpiredViewModel: BaseViewModel {

    // MARK: - Properties

    var data: DataModel

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
    }
}

// MARK: - LinkExpiredViewModel.DataModel
extension LinkExpiredViewModel {

    class DataModel {

        enum Mode {
            case registration
            case forgotPassword
        }

        // MARK: - Properties

        var mode: Mode
        var description: String

        // MARK: - Constructors/Destructors

        init(mode: Mode) {
            self.mode = mode
            switch mode {
            case .registration:
                self.description = "FIX ME"
            case .forgotPassword:
                self.description = "Your link has expired, because you have not used it. Reset password link expires in every 24 hours and can be used only once. You can create a new one by clicking the button below."
            }
        }
    }
}
