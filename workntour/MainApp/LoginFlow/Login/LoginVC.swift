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

        loginBtn.isEnabled = true
        credentialsStackView.setCustomSpacing(16, after: emailTextField)
        forgotPasswordBtn.underline()
        setupNavigationBar(mainTitle: "Log in")
        emailTextField.configure(placeHolder: "Enter your email", type: .email)
        passwordTextField.configure(placeHolder: "Enter your password", type: .password)
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

    // MARK: - Actions
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .forgotPassword)
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .successfulLogin)
    }
}
