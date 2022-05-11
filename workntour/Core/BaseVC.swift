//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import Combine

typealias DisposeBag = Set<AnyCancellable>

class BaseVC: UIViewController {

    var storage: DisposeBag = []

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViews()
    }

    func bindViews() {}

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
