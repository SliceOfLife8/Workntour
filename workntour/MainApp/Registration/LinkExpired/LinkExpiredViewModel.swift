//
//  LinkExpiredViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 5/1/23.
//

import SharedKit
import Combine

class LinkExpiredViewModel: BaseViewModel {

    private var service: AuthorizationService

    // Outputs
    @Published var linkWasSent: Bool = false

    // MARK: - Properties

    var data: DataModel

    // MARK: - Init
    
    required init(
        service: AuthorizationService = DataManager.shared,
        data: DataModel
    ) {
        self.service = service
        self.data = data
    }

    func resendRegistrationVerificationLink(_ token: String) {
        service.updateVerificationRegistration(with: token)
            .subscribe(on: DispatchQueue.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .assign(to: &$linkWasSent)
    }
}

// MARK: - LinkExpiredViewModel.DataModel
extension LinkExpiredViewModel {

    class DataModel {

        // MARK: - Properties

        var description: String
        let token: String

        // MARK: - Constructors/Destructors

        init(token: String) {
            self.description = "email_veritification_expired_link".localized()
            self.token = token
        }
    }
}
