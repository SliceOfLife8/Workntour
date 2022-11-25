//
//  NotificationsVC.swift
//  workntour
//
//  Created by Chris Petimezas on 17/6/22.
//

import UIKit
import SharedKit

class NotificationsVC: BaseVC<NotificationsViewModel, NotificationsCoordinator> {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Notifications"
    }
}
