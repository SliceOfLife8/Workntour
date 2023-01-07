//
//  ForgotPasswordRequestLinkVC.swift
//  workntour
//
//  Created by Chris Petimezas on 4/1/23.
//

import UIKit
import CommonUI

class ForgotPasswordRequestLinkVC: BaseVC<ForgotPasswordRequestLinkViewModel, LoginCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var mainScrollView: UIScrollView!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "forgot_password".localized()
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "forgot_password_description".localized()
        }
    }

    @IBOutlet weak var emailTitleLabel: UILabel! {
        didSet {
            emailTitleLabel.text = String("email".localized().dropLast())
        }
    }

    @IBOutlet weak var emailTextField: GradientTextField! {
        didSet {
            emailTextField.configure(
                placeHolder: "registered_email".localized(),
                type: .email
            )
            emailTextField.gradientDelegate = self
        }
    }

    @IBOutlet weak var emailError: UILabel! {
        didSet {
            emailError.text = "invalid_registered_email".localized()
        }
    }

    @IBOutlet weak var requestLinkButton: PrimaryButton! {
        didSet {
            requestLinkButton.setTitle(
                "request_password_link".localized(),
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

    // MARK: - Properties

    private var keyboardHeight: CGFloat = 0

    private var keyboardHasAppearedAtLeastOnce: Bool = false

    // MARK: - Constructors/Destructors

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        estimateHeight()
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$linkWasSent
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] status in
                self?.dismiss(animated: true, completion: {
                    if status {
                        self?.coordinator?.navigate(
                            to: .state(.showAlert(
                                title: "",
                                subtitle: "forgot_password_successful_message".localized()
                            ))
                        )
                    }
                    else {
                        self?.coordinator?.navigate(
                            to: .state(.showAlert(title: "Error message", subtitle: "Something went wrong!"))
                        )
                    }
                })
            })
            .store(in: &storage)
    }

    // MARK: - Private Methods

    private func estimateHeight() {
        if let stackViews = mainScrollView.subviews.first?.subviews.compactMap({ $0 as? UIStackView }) {
            let stackViewsTotalHeight = stackViews.map { $0.bounds.height }.reduce(0, +) + 50 // Top & Bottom anchors
            UIView.animate(
                withDuration: keyboardHasAppearedAtLeastOnce ? 0.25 : 0,
                delay: 0
            ) { [unowned self] in
                self.preferredContentSize = CGSize(
                    width: mainScrollView.frame.width,
                    height: stackViewsTotalHeight + keyboardHeight
                )
            }
        }
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Actions

    @IBAction func requestLinkBtnTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              email.isEmailValid()
        else {
            UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
                self.emailError.isHidden = false
                self.emailTextField.setGradientLayer(borderWidth: 1, hasError: true)
                self.emailTextField.errorOccured = true
            }
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0) { [unowned self] in
            self.emailError.isHidden = true
            self.emailTextField.errorOccured = false
        }

        viewModel?.requestResetPasswordLink(withEmail: email)
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Keyboard Notifications
extension ForgotPasswordRequestLinkVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardHeight = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        keyboardHasAppearedAtLeastOnce = true
        view.setNeedsLayout()
    }

    @objc private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
        view.setNeedsLayout()
    }
}

// MARK: - GradientTFDelegate
extension ForgotPasswordRequestLinkVC: GradientTFDelegate {

    func shouldReturn(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
