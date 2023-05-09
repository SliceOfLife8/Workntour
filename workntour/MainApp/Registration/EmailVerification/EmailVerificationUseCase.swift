//
//  EmailVerificationUseCase.swift
//  workntour
//
//  Created by Chris Petimezas on 8/5/23.
//

import UIKit
import Combine
import SharedKit
import BottomSheet

class EmailVerificationUseCase {

    // MARK: - Properties

    private(set) var token: String

    private var service: AuthorizationService

    private var rootViewController: AppRootVC

    private var mainCoordinator: MainCoordinator

    private var storage = Set<AnyCancellable>()

    @Published var verified: Bool = false
    @Published var errorCode: Int?

    // MARK: - Constructors/Destructors

    init(
        service: AuthorizationService = DataManager.shared,
        token: String,
        rootViewController: AppRootVC,
        mainCoordinator: MainCoordinator
    ) {
        self.service = service
        self.token = token
        self.rootViewController = rootViewController
        self.mainCoordinator = mainCoordinator

        self.$verified
            .sink { bool in
                if bool {
                    AlertHelper.showDefaultAlert(
                        self.rootViewController,
                        title: "account_activation".localized(),
                        message: "account_activation_description".localized(),
                        dismissCompletion: {
                            mainCoordinator.navigate(to: .login)
                        })
                }
            }
            .store(in: &storage)

        // Silently ignore all errors expect that one with 410 statusCode.
        self.$errorCode
            .compactMap { $0 }
            .sink { [weak self] code in
                if code == 410 {
                    self?.linkWasExpired()
                }
            }
            .store(in: &storage)
    }

    deinit {
        storage.cancelAll()
    }

    // MARK: - Methods

    /// Verify that token is valid, otherwise throw an error.
    func verify() {
        rootViewController.showLoader()

        service.verifyRegistration(with: token)
            .subscribe(on: DispatchQueue.main)
            .catch({ [weak self] error -> Just<Bool> in

                if case .invalidServerResponseWithStatusCode(let code) = error {
                    self?.errorCode = code
                } else {
                    self?.errorCode = 500
                }

                return Just(false)
            })
                .handleEvents(receiveCompletion: { _ in
                    self.rootViewController.stopLoader()
                })
                .assign(to: &$verified)

    }

    private func linkWasExpired() {
        let expiredVC = LinkExpiredVC()
        expiredVC.viewModel = LinkExpiredViewModel(data: .init(token: token))
        expiredVC.coordinator = mainCoordinator.parent

        rootViewController.presentBottomSheet(
            viewController: expiredVC,
            configuration: BottomSheetConfiguration(
                cornerRadius: 16,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }
}
