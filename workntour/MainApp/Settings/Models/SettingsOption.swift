//
//  SettingsOption.swift
//  workntour
//
//  Created by Chris Petimezas on 20/6/22.
//

import UIKit

struct Section {
    let title: String?
    let bottomTitle: String?
    var options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor?
    var accessoryType: UITableViewCell.AccessoryType
    let handle: (() -> Void)
}
