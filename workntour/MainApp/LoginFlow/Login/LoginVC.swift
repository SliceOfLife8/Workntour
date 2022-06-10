//
//  LoginVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 9/6/22.
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
    }

    override func setupTexts() {
        super.setupTexts()

        loginBtn.setTitle("Log in", for: .normal)
        registrationLabel.text = "Not a member? Register here"
        let actionPart = "Register here"
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
        setupNavigationBar(mainTitle: "Log in")
        emailTextField.configure(placeHolder: "Enter your email", text: viewModel?.email, type: .email)
        passwordTextField.configure(placeHolder: "Enter your password", text: viewModel?.password, type: .password)

        emailTextField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.validatedCredentials
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginBtn)
            .store(in: &storage)

        viewModel?.$loaderVisibility
            .sink { [weak self] status in
                if status {
                    self?.showLoader()
                } else {
                    self?.stopLoader()
                }
            }
            .store(in: &storage)

        viewModel?.$errorMessage
            .dropFirst()
            .sink(receiveValue: { [weak self] error in
                if let errorDescription = error {
                    self?.coordinator?.navigate(to: .errorDialog(description: errorDescription))
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

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }

        return true
    }
}
