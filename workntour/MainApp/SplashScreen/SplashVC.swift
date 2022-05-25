//
//  SplashVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import UIKit
import SharedKit

class SplashVC: BaseVC<SplashViewModel, MainCoordinator> {

//    private lazy var logoIcon: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = .init(named: "logo")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()

    private lazy var illustration: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(named: "splash_illustration")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Inits
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //logoIcon.addExclusiveConstraints(superview: view, top: (view.safeAreaLayoutGuide.topAnchor, 75), width: 45, height: 45, centerX: (view.centerXAnchor, 0))
        //illustration.addExclusiveConstraints(superview: view, top: (logoIcon.bottomAnchor, 18), left: (view.leadingAnchor, 0), right: (view.trailingAnchor, 0), height: 300)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated)
    }

}
