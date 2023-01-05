//
//  ForgotPasswordRequestLinkViewModel.swift
//  workntour
//
//  Created by Chris Petimezas on 4/1/23.
//

import SharedKit

class ForgotPasswordRequestLinkViewModel: BaseViewModel {
    // Services
    private var authorizationService: AuthorizationService

    // Outputs
    @Published var linkWasSent: Bool?

    // MARK: - Constructors/Desctructors

    init(authorizationService: AuthorizationService = DataManager.shared) {
        self.authorizationService = authorizationService

        super.init()
    }

    // MARK: - Methods

    func requestResetPasswordLink(withEmail email: String) {
        print("call api")
        linkWasSent = true
        // Upon successful response store key
//        LocalStorageManager.shared.save(
//            email,
//            forKey: .emailForgotPassword,
//            withMethod: .userDefaults
//        )
    }
}
