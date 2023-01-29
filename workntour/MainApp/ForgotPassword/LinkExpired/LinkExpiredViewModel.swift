//
//  LinkExpiredViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 5/1/23.
//

import SharedKit

class LinkExpiredViewModel: BaseViewModel {

    // Outputs
    @Published var linkWasSent: Bool?

    // MARK: - Properties

    var data: DataModel

    // MARK: - Init

    required init(data: DataModel) {
        self.data = data
    }

    func requestResetPasswordLink(withEmail email: String) {
        print("call api")
        linkWasSent = true
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
                self.description = "link_expired_description".localized()
            }
        }
    }
}
