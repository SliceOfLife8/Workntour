//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import Combine
import SharedKit
import SnapKit
import NVActivityIndicatorView

typealias DisposeBag = Set<AnyCancellable>

class BaseVC<VM: BaseViewModel, C: Coordinator>: UIViewController {
    /// Setup your own classes.
    var viewModel: VM?
    weak var coordinator: C?

    var storage = Set<AnyCancellable>()
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

        if self is SplashVC || self is HostProfileVC || self is OpportunityDetailsVC {
            hideNavigationBar(animated)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (self is SplashVC || self is HostProfileVC || self is OpportunityDetailsVC) && !preventNavBarFromAppearing {
            showNavigationBar(animated)
        } else if self is LoginVC {
            hideNavigationBar(animated)
        }
        preventNavBarFromAppearing = false
    }

    func bindViews() {
        viewModel?.$loaderVisibility
            .sink { [weak self] status in
                if status {
                    self?.showLoader()
                } else {
                    self?.stopLoader()
                }
            }
            .store(in: &storage)
    }

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

class BaseViewModel {
    /// Outputs
    @Published var loaderVisibility: Bool = false
}

class EmptyViewModel: BaseViewModel {}

// MARK: - Loader
extension BaseVC {
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

// MARK: - Keyboard extensions
extension BaseVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
