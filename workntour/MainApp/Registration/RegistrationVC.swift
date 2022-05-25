//
//  RegistrationVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/5/22.
//

import UIKit

class RegistrationVC: BaseVC<RegistrationViewModel, MainCoordinator> {

    private var localIdentifier: String {
        Locale.current.collatorIdentifier ?? Locale.current.identifier
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        // self.viewModel?.input.send(())

        NSLocale.isoCountryCodes.forEach { code in
            if let name = Locale(identifier: localIdentifier).localizedString(forRegionCode: code) {
                print("name: \(name), code: \(code)")
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

}
