//
//  ThemeManager.swift
//  workntour
//
//  Created by Chris Petimezas on 13/11/22.
//

import UIKit
import SharedKit
import SkeletonView

class ThemeManager {

    static let shared = ThemeManager()

    func updateStyle() {
        updateSegmenedControlStyle()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.appColor(.lightGray)
    }

    private func updateSegmenedControlStyle() {
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .normal
        )
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.appColor(.purple)
    }
}
