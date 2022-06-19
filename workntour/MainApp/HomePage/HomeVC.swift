//
//  HomeVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit

class HomeVC: BaseVC<HomeViewModel, HomeCoordinator> {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"
    }

}
