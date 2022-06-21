//
//  SettingsViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import Combine
import UIKit
import SharedKit

class SettingsViewModel: BaseViewModel {
    /// Inputs
    @Published var data = [Section]()
    /// Outputs
    @Published var logoutAction: Bool = false

    func fetchOptions() {
        let generalOptions = [SettingsOption(title: "Logout",
                                             icon: UIImage(systemName: "arrow.uturn.left.square"),
                                             iconBackgroundColor: UIColor.appColor(.lavender),
                                             accessoryType: .disclosureIndicator,
                                             handle: { [weak self] in
            self?.logoutAction = true
        })]

        data.append(Section(title: "General", bottomTitle: nil, options: generalOptions))
    }
}
