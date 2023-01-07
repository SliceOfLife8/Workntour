//
//  LinkExpiredVC.swift
//  workntour
//
//  Created by Chris Petimezas on 5/1/23.
//

import UIKit
import CommonUI

class LinkExpiredVC: BaseVC<LinkExpiredViewModel, LoginCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "LINK EXPIRED"
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "Your link has expired, because you have not used it. Reset password link expires in every 24 hours and can be used only once. You can create a new one by clicking the button below."
        }
    }

    @IBOutlet weak var resendLinkButton: PrimaryButton! {
        didSet {
            resendLinkButton.setTitle(
                "Resend another link",
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
