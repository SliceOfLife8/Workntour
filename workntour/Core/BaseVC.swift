//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import Combine
import SharedKit

/*
 1. Localization of app (Greek & English) and change texts live.
 2. Observe networking status
 */

typealias DisposeBag = Set<AnyCancellable>

class BaseVC<VM: BaseViewModel, C: Coordinator>: UIViewController {
    /// Setup your own classes.
    var viewModel: VM?
    var coordinator: C?

    var storage: DisposeBag = []

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
        setupTexts()
        trackScreen()
    }

    func bindViews() {}

    /// #Override this method in order to receive language real-time changes.
    func setupTexts() {}

    private func trackScreen() {
        let currentVC = String(describing: type(of: self))
        FirebaseManager.sharedInstance.trackScreen(currentVC)
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
