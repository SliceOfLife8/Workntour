//
//  RegistrationHostVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 8/6/22.
//

import UIKit

class RegistrationHostVC: BaseVC<RegistrationHostViewModel, RegistrationCoordinator> {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }

    // MARK: - Actions
    @objc private func closeBtnTapped() {
        self.coordinator?.navigate(to: .close)
    }
}

// MARK: - Basic setup
private extension RegistrationHostVC {
    private func setupNavBar() {
        self.setupNavigationBar(mainTitle: "Sign up")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTapped))
    }
}
