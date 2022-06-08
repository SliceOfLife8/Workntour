//
//  EmailVerificationVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 8/6/22.
//

import UIKit
import SharedKit

class EmailVerificationVC: BaseVC<EmailVerificationViewModel, RegistrationCoordinator> {

    private(set) var email: String

    // MARK: - Vars
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.lavender)
        label.font = UIFont.scriptFont(.bold, size: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Check your Inbox!"
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appColor(.softBlack)
        label.font = UIFont.scriptFont(.regular, size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setLineHeight(lineHeight: 1.33)
        label.text = "Click the link we sent to \(email) to sign in."
        return label
    }()

    private lazy var mainIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email_verification")
        return imageView
    }()

    // MARK: - Inits
    init(_ email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.appColor(.primary)
        setupNavBar()
    }

    private func setupNavBar() {
        setupNavigationBar(mainTitle: "Email verification")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTapped))
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false // Disable swipe-back gesture
    }

    override func setupUI() {
        super.setupUI()

        titleLabel.addExclusiveConstraints(superview: view,
                                           top: (view.safeAreaLayoutGuide.topAnchor, 32),
                                           left: (view.leadingAnchor, 24),
                                           right: (view.trailingAnchor, 24))
        descriptionLabel.addExclusiveConstraints(superview: view,
                                                 top: (titleLabel.bottomAnchor, 8),
                                                 left: (titleLabel.leadingAnchor, 0),
                                                 right: (titleLabel.trailingAnchor, 0))
        mainIcon.addExclusiveConstraints(superview: view,
                                         top: (descriptionLabel.bottomAnchor, 32),
                                         left: (descriptionLabel.leadingAnchor, 0),
                                         right: (descriptionLabel.trailingAnchor, 0))
    }

    @objc private func closeBtnTapped() {
        self.coordinator?.navigate(to: .close)
    }
}
