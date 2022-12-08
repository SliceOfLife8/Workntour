//
//  LoginVC.swift
//  workntour
//
//  Created by Chris Petimezas on 9/6/22.
//

import UIKit
import Combine
import CommonUI

class LoginVC: BaseVC<LoginViewModel, LoginCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var credentialsStackView: UIStackView!
    @IBOutlet weak var emailTextField: GradientTextField!
    @IBOutlet weak var passwordTextField: GradientTextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var rememberMeBtn: Checkbox!
    @IBOutlet weak var loginBtn: PrimaryButton!
    @IBOutlet weak var registrationLabel: LinkableLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        rememberMeBtn.isChecked = true
    }

    override func setupTexts() {
        super.setupTexts()

        loginBtn.setTitle("login".localized(), for: .normal)
        registrationLabel.text = "new_member".localized()
        let actionPart = "new_member_action_part".localized()
        registrationLabel.changeFont(ofText: actionPart, with: UIFont.scriptFont(.bold, size: 14))
        registrationLabel.changeTextColor(ofText: actionPart, with: UIColor.appColor(.mint))

        registrationLabel.onCharacterTapped = { [weak self] label, index in
            if label.text?.wordExistsOnTappableArea(word: actionPart, index: index) == true {
                self?.coordinator?.navigate(to: .register)
            }
        }
    }

    override func setupUI() {
        super.setupUI()

        credentialsStackView.setCustomSpacing(16, after: emailTextField)
        forgotPasswordBtn.underline()
        setupNavigationBar(mainTitle: "login".localized())
        emailTextField.configure(
            placeHolder: "email_placeholder".localized(),
            text: viewModel?.email,
            type: .email
        )
        passwordTextField.configure(
            placeHolder: "password_placeholder".localized(),
            text: viewModel?.password,
            type: .password
        )

        emailTextField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        emailTextField.gradientDelegate = self
        passwordTextField.gradientDelegate = self
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.validatedCredentials
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginBtn)
            .store(in: &storage)

        viewModel?.$errorMessage
            .dropFirst()
            .sink(receiveValue: { [weak self] error in
                if let errorDescription = error {
                    self?.coordinator?.navigate(to: .errorDialog(description: errorDescription))
                }
            })
            .store(in: &storage)

        viewModel?.$userLoggedIn
            .sink(receiveValue: { [weak self] model in
                if let _model = model {
                    self?.viewModel?.retrieveProfile(_model)
                }
            })
            .store(in: &storage)

        viewModel?.$userIsEligible
            .sink(receiveValue: { [weak self] status in
                if status {
                    let autoSave = self?.rememberMeBtn.isChecked ?? false
                    self?.viewModel?.handleCredentials(store: autoSave)

                    self?.coordinator?.navigate(to: .successfulLogin)
                }
            })
            .store(in: &storage)
    }

    // MARK: - Actions
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .forgotPassword)
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        viewModel?.loginUser()
    }

    @objc private func emailDidChange() {
        viewModel?.email = emailTextField.text ?? ""
    }

    @objc private func passwordDidChange() {
        viewModel?.password = passwordTextField.text ?? ""
    }

}

extension LoginVC: GradientTFDelegate {
    func shouldReturn(_ textField: UITextField) {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
    }
}
