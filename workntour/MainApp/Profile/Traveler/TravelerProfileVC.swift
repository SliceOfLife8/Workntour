//
//  TravelerProfileVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 15/6/22.
//

import UIKit
import SharedKit

class TravelerProfileVC: BaseVC<TravelerProfileViewModel, ProfileCoordinator> {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
    }
}
