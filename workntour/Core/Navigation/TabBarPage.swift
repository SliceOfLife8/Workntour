//
//  TabBarPage.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit

enum TabBarPage: CaseIterable {
    case homepage
    case profile
    case opportunities
    case notifications
    case settings

    init?(index: Int) {
        switch index {
        case 0:
            self = .homepage
        case 1:
            self = .profile
        case 2:
            self = .opportunities
        case 3:
            self = .notifications
        case 4:
            self = .settings
        default:
            assertionFailure("TabBarPage index out of range!")
            return nil
        }
    }

    var pageTitleValue: String {
        switch self {
        case .homepage:
            return "Home"
        case .profile:
            return "Profile"
        case .opportunities:
            return "Opportunities"
        case .notifications:
            return "Notifications"
        case .settings:
            return "Settings"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .homepage:
            return 0
        case .profile:
            return 1
        case .opportunities:
            return 2
        case .notifications:
            return 3
        case .settings:
            return 4
        }
    }

    var tabIcon: UIImage? {
        let name: String

        switch self {
        case .homepage:
            name = "homeIcon"
        case .profile:
            name = "profileIcon"
        case .opportunities:
            name = "opportunitiesIcon"
        case .notifications:
            name = "notificationsIcon"
        case .settings:
            name = "settingsIcon"
        }

        return UIImage(named: name)
    }

    var tabSelectedIcon: UIImage? {
        let name: String

        switch self {
        case .homepage:
            name = "homeSelectedIcon"
        case .profile:
            name = "profileSelectedIcon"
        case .opportunities:
            name = "opportunitiesSelectedIcon"
        case .notifications:
            name = "notificationsSelectedIcon"
        case .settings:
            name = "settingsSelectedIcon"
        }

        return UIImage(named: name)
    }
}
