//
//  LinkExpiredVC.swift
//  workntour
//
//  Created by Chris Petimezas on 5/1/23.
//

import UIKit
import CommonUI

class LinkExpiredVC: BaseVC<LinkExpiredViewModel, AppCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "link_expired".localized()
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "link_expired_description".localized()
        }
    }

    @IBOutlet weak var resendLinkButton: PrimaryButton! {
        didSet {
            resendLinkButton.setTitle(
                "resend_link".localized(),
                for: .normal
            )
        }
    }

    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle(
                "cancel".localized(),
                for: .normal
            )
        }
    }

    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        estimateHeight()
    }

    // MARK: - Private Methods

    private func estimateHeight() {
        if let stackViews = view.subviews.first?.subviews.compactMap({ $0 as? UIStackView }) {
            let stackViewsTotalHeight = stackViews.map { $0.bounds.height }.reduce(0, +) + 100
            self.preferredContentSize = CGSize(
                width: view.frame.width,
                height: stackViewsTotalHeight
            )
        }
    }


    // MARK: - Actions

    @IBAction func resendLinkButtonTapped(_ sender: Any) {
        print("okei")
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
