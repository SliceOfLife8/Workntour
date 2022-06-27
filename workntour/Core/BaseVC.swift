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

typealias DisposeBag = Set<AnyCancellable>

class BaseVC<VM: BaseViewModel, C: Coordinator>: UIViewController {
    /// Setup your own classes.
    var viewModel: VM?
    weak var coordinator: C?

    var storage = Set<AnyCancellable>()
    private let loaderTag = 1938123987
    var preventNavBarFromAppearing: Bool = false /// This variable is used from prevent navigationBar from appearing. This is basically used when we want two behaviours for the same ViewController.

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
        setupUI()
        setupTexts()
        trackScreen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self is SplashVC || self is HostProfileVC {
            hideNavigationBar(animated)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (self is SplashVC || self is HostProfileVC) && !preventNavBarFromAppearing {
            showNavigationBar(animated)
        } else if self is LoginVC {
            hideNavigationBar(animated)
        }
        preventNavBarFromAppearing = false
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

class EmptyViewModel: BaseViewModel {}

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
