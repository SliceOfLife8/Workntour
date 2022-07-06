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

        [titleLabel, descriptionLabel, mainIcon].forEach {
            view.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalTo(titleLabel.snp.left)
            $0.right.equalTo(titleLabel.snp.right)
        }

        mainIcon.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.left.equalTo(descriptionLabel.snp.left)
            $0.right.equalTo(descriptionLabel.snp.right)
        }
    }

    @objc private func closeBtnTapped() {
        self.coordinator?.navigate(to: .close)
    }
}
