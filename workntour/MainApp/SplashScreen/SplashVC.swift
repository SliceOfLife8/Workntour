//
//  SplashVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import UIKit
import SharedKit
import CommonUI

class SplashVC: BaseVC<SplashViewModel, MainCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var loginBtn: PrimaryButton!
    @IBOutlet weak var loginAsGuestBtn: SecondaryButton!
    @IBOutlet weak var registrationPoint: LinkableLabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated)
    }

    override func setupTexts() {
        super.setupTexts()
        loginBtn.setTitle("Log in", for: .normal)
        loginAsGuestBtn.setTitle("Log in as a guest", for: .normal)

        registrationPoint.text = "Not a member? Register here"
        let actionPart = "Register here"
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
        self.coordinator?.navigate(to: .loginAsGuest)
    }
}
