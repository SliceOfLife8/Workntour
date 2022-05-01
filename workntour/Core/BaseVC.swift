//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit
import Combine
import Networking

class BaseVC: UIViewController {

    var storage: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print("something else !")
        let networking = Networking()
        // networking.preference.isDebuggingEnabled = true
        let publisher = networking.request(
            with: MockTarget.test,
            scheduler: DispatchQueue.main,
            class: Welcome.self)

        publisher.sink(receiveCompletion: { print ("completion: \($0)") },
                        receiveValue: { print ("value: \($0)") })
            .store(in: &self.storage)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(String(describing: type(of: self))) deinitialized")
    }

}
