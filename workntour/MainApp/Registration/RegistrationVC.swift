//
//  RegistrationVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/5/22.
//

import UIKit
import SharedKit

class RegistrationVC: BaseVC<RegistrationViewModel, RegistrationCoordinator> {

    private var localIdentifier: String {
        Locale.current.collatorIdentifier ?? Locale.current.identifier
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appColor(.primary)
        self.setupNavigationBar(mainTitle: "Sign up")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTapped))

        // self.viewModel?.input.send(())

        NSLocale.isoCountryCodes.forEach { code in
            if let name = Locale(identifier: localIdentifier).localizedString(forRegionCode: code) {
               // print("name: \(name), code: \(code)")
            }
        }
    }

    override func bindViews() {
        viewModel?.$hole
            .dropFirst()
            .sink(receiveCompletion: { print("completion: \($0)") },
                  receiveValue: {
            })
            .store(in: &storage)

        viewModel?.$errorMessage
            .dropFirst()
            .sink { [weak self] message in
            }
            .store(in: &storage)
    }

    @objc
    private func closeBtnTapped() {
        self.coordinator?.navigate(to: .close)
    }

}
