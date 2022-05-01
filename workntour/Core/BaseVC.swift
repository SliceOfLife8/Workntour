//
//  BaseVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(String(describing: type(of: self))) deinitialized")
    }

}
