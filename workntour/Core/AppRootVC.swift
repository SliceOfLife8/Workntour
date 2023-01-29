//
//  AppRootVC.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import UIKit
import SharedKit
import NVActivityIndicatorView

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

    // MARK: - Loader

    func showLoader(_ type: NVActivityIndicatorType = .ballRotateChase) {
        if view.subviews.filter({ $0 is UIVisualEffectView }).first != nil {
            return
        }
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.95
        blurEffectView.frame = self.view.bounds
        self.view.insertSubview(blurEffectView, at: 0)
        self.view.bringSubviewToFront(blurEffectView)

        let spinner = NVActivityIndicatorView(frame: .zero, type: type, color: UIColor.appColor(.lavender), padding: 8)
        spinner.startAnimating()
        blurEffectView.contentView.addSubview(spinner)
        spinner.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
    }

    func stopLoader() {
        let blurEffectView = view.subviews.filter { $0 is UIVisualEffectView }.first
        blurEffectView?.removeFromSuperview()
    }
}
