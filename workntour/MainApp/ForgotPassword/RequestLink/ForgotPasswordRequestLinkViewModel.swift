//
//  ForgotPasswordRequestLinkViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 4/1/23.
//

import Combine
import SharedKit

class ForgotPasswordRequestLinkViewModel: BaseViewModel {
    // Services
    private var authorizationService: AuthorizationService

    // Outputs
    @Published var linkWasSent: Bool = false

    // MARK: - Constructors/Destructors

    init(authorizationService: AuthorizationService = DataManager.shared) {
        self.authorizationService = authorizationService

        super.init()
    }

    // MARK: - Methods

    func requestResetPasswordLink(withEmail email: String) {
        authorizationService.forgotPassword(email: email)
            .subscribe(on: DispatchQueue.main)
            .catch({ _ -> Just<Bool> in
                return Just(false)
            })
                .assign(to: &$linkWasSent)
    }
}
