//
//  SplashVC.swift
//  workntour
//
//  Created by Chris Petimezas on 11/5/22.
//

import UIKit
import SharedKit
import CommonUI

class SplashVC: BaseVC<SplashViewModel, MainCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var loginBtn: PrimaryButton!

    @IBOutlet weak var loginAsGuestBtn: SecondaryButton!

    @IBOutlet weak var appleLoginBtn: SecondaryButton! {
        didSet {
            appleLoginBtn.layer.borderColor = UIColor.appColor(.separator).cgColor
        }
    }

    @IBOutlet weak var googleLoginBtn: SecondaryButton! {
        didSet {
            googleLoginBtn.layer.borderColor = UIColor.appColor(.separator).cgColor
        }
    }

    @IBOutlet weak var registrationPoint: LinkableLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Don't remove this line. Ask me!
        setupNavigationBar(mainTitle: nil)
    }

    override func setupTexts() {
        super.setupTexts()
        loginBtn.setTitle("login".localized(), for: .normal)
        loginAsGuestBtn.setTitle("guest_login".localized(), for: .normal)
        appleLoginBtn.setTitle("apple_login".localized(), for: .normal)
        googleLoginBtn.setTitle("google_login".localized(), for: .normal)

        registrationPoint.text = "new_member".localized()
        let actionPart = "new_member_action_part".localized()
        registrationPoint.changeFont(ofText: actionPart, with: UIFont.scriptFont(.bold, size: 14))
        registrationPoint.changeTextColor(ofText: actionPart, with: UIColor.appColor(.mint))

        registrationPoint.onCharacterTapped = { [weak self] label, index in
            if label.text?.wordExistsOnTappableArea(word: actionPart, index: index) == true {
                self?.coordinator?.navigate(to: .registrationPoint)
            }
        }
    }

    // MARK: - Actions

    @IBAction func loginBtnTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .login)
    }

    @IBAction func loginAsGuestBtnTapped(_ sender: Any) {
        self.preventNavBarFromAppearing = true
        self.coordinator?.navigate(to: .loginAsGuest)
    }

    @IBAction func appleLoginBtnTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .appleLogin)
    }

    @IBAction func googleLoginBtnTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .googleLogin)
    }
}
