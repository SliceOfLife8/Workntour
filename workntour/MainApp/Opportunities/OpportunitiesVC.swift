//
//  OpportunitiesVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 15/6/22.
//

import UIKit
import SharedKit

/*
 1. Create a list of opportunities. Basically it's a collectionView. https://github.com/appssemble/appstore-card-transition
 2. Create an opportunity. We need to integrate the AirBnb's calendar https://github.com/airbnb/HorizonCalendar.
 3. Details View.
 4. Delete option on detailsView.
 */

class OpportunitiesVC: BaseVC<OpportunitiesViewModel, OpportunitiesCoordinator> {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Opportunities"
    }

}
