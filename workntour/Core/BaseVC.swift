//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import Combine

class BaseVC: UIViewController {

    var storage: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let publisher = AuthorizationDataRequests.shared.userRegistration()

            publisher.sink(receiveCompletion: { print("completion: \($0)") },
                           receiveValue: { print("value: \($0)") })
                .store(in: &self.storage)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("☠️ \(String(describing: type(of: self))) deinitialized")
    }

}
