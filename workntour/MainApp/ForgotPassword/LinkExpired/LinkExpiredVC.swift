//
//  LinkExpiredVC.swift
//  workntour
//
//  Created by Chris Petimezas on 5/1/23.
//

import UIKit
import CommonUI
import SharedKit

class LinkExpiredVC: BaseVC<LinkExpiredViewModel, AppCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "link_expired".localized()
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "link_expired_description".localized()
        }
    }

    @IBOutlet weak var resendLinkButton: PrimaryButton! {
        didSet {
            resendLinkButton.setTitle(
                "resend_link".localized(),
                for: .normal
            )
        }
    }

    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle(
                "cancel".localized(),
                for: .normal
            )
        }
    }

    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        estimateHeight()
    }

    override func bindViews() {
        super.bindViews()
        let mainCoordinator = coordinator?.childCoordinators.first as? MainCoordinator

        viewModel?.$linkWasSent
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] status in
                self?.dismiss(
                    animated: true,
                    completion: {
                        if status {
                            mainCoordinator?.navigate(
                                to: .showGenericAlert(
                                    title: "",
                                    subtitle: "forgot_password_successful_message".localized()
                                )
                            )
                        }
                        else {
                            mainCoordinator?.navigate(
                                to: .showGenericAlert(
                                    title: "Error message",
                                    subtitle: "Something went wrong!"
                                )
                            )
                        }
                    })
            })
            .store(in: &storage)
    }

    // MARK: - Private Methods

    private func estimateHeight() {
        if let stackViews = view.subviews.first?.subviews.compactMap({ $0 as? UIStackView }) {
            let stackViewsTotalHeight = stackViews.map { $0.bounds.height }.reduce(0, +) + 100
            self.preferredContentSize = CGSize(
                width: view.frame.width,
                height: stackViewsTotalHeight
            )
        }
    }

    // MARK: - Actions

    @IBAction func resendLinkButtonTapped(_ sender: Any) {
        if let storedEmail = LocalStorageManager.shared.retrieve(
            forKey: .emailForgotPassword,
            type: String.self
        ) {
            viewModel?.requestResetPasswordLink(withEmail: storedEmail)
        }
        else {
            self.dismiss(
                animated: true,
                completion: { [weak self] in
                    // Show ForgotPasswordRequestLink screen.
                    let mainCoordinator = self?.coordinator?.childCoordinators.first as? MainCoordinator
                    if let loginCoordinator = mainCoordinator?.childCoordinators
                        .compactMap({ $0 as? LoginCoordinator }).first {
                        loginCoordinator.navigate(to: .forgotPassword)
                    }
                    else {
                        mainCoordinator?.navigate(to: .login)
                        (mainCoordinator?.childCoordinators.last as? LoginCoordinator)?.navigate(to: .forgotPassword)
                    }
                })
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
