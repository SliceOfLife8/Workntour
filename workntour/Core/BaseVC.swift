//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import Combine
import SharedKit
import NVActivityIndicatorView

/*
 1. Localization of app (Greek & English) and change texts live.
 2. Observe networking status
 */

typealias DisposeBag = Set<AnyCancellable>

class BaseVC<VM: BaseViewModel, C: Coordinator>: UIViewController {
    /// Setup your own classes.
    var viewModel: VM?
    weak var coordinator: C?

    var storage = Set<AnyCancellable>()
    private let loaderTag = 1938123987

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
        setupUI()
        setupTexts()
        trackScreen()
    }

    func bindViews() {}

    func setupUI() {}

    /// #Override this method in order to receive language real-time changes.
    func setupTexts() {}

    private func trackScreen() {
        let currentVC = String(describing: type(of: self))
        FirebaseManager.sharedInstance.trackScreen(currentVC)
    }

    @objc private func dismissKeyboardView() {
        view.endEditing(true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        storage.cancelAll()
        print("☠️ \(String(describing: type(of: self))) deinitialized")
    }
}

private extension DisposeBag {
    mutating func cancelAll() {
        forEach { $0.cancel() }
        removeAll()
    }
}

class BaseViewModel { }

// MARK: - Loader
extension BaseVC {
    func showLoader(_ type: NVActivityIndicatorType = .ballRotateChase) {
        var spinner = view.viewWithTag(loaderTag) as? NVActivityIndicatorView
        if spinner == nil {
            spinner = NVActivityIndicatorView(frame: .zero, type: type, color: UIColor.appColor(.lavender), padding: 8)
        }

        spinner?.translatesAutoresizingMaskIntoConstraints = false
        spinner?.startAnimating()
        spinner?.tag = loaderTag
        view.isUserInteractionEnabled = false
        spinner?.addExclusiveConstraints(superview: view, width: 80, height: 80, centerX: (view.centerXAnchor, 0), centerY: (view.centerYAnchor, 0))
    }

    func stopLoader() {
        let spinner = view.viewWithTag(loaderTag) as? NVActivityIndicatorView
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}

// MARK: - Keyboard extensions
extension BaseVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
