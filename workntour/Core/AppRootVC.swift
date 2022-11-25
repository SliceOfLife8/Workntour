//
//  AppRootVC.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import UIKit
import SharedKit

/** The app's root controller - a `UIViewController` which simply holds a child `UIViewController`. */

final class AppRootVC: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    func set(childViewController controller: UIViewController) {
        addChild(controller)
        controller.didMove(toParent: self)

        let childView = controller.view!
        view.addSubview(childView, constraints: [childView.topAnchor.constraint(equalTo: view.topAnchor),
                                                 childView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                                 childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                                 childView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }

}
