//
//  ProfileAddSummaryVC.swift
//  workntour
//
//  Created by Chris Petimezas on 14/11/22.
//

import UIKit
import SharedKit

class ProfileAddSummaryVC: BaseVC<ProfileAddSummaryViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.borderColor = UIColor.appColor(.purple).cgColor
            mainView.layer.borderWidth = 1
            mainView.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.dataDetectorTypes = .link
            descriptionTextView.returnKeyType = .done
            descriptionTextView.delegate = self
        }
    }

    @IBOutlet weak var limitLabel: UILabel!

    @IBOutlet weak var placeholderLabel: UILabel!

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel else { return }

        setupNavigationBar(mainTitle: viewModel.data.navigationBarTitle)
        let saveAction = UIBarButtonItem(
            title: "save".localized(),
            style: .plain,
            target: self,
            action: #selector(saveBtnTapped)
        )
        navigationItem.rightBarButtonItems = [saveAction]
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func setupUI() {
        super.setupUI()

        guard let viewModel else { return }

        let currentCharacters = viewModel.data.description?.count ?? 0

        limitLabel.text = "\(currentCharacters)/\(viewModel.data.charsLimit)"
        if let currentText = viewModel.data.description {
            placeholderLabel.isHidden = true
            descriptionTextView.text = currentText
        }
        else {
            placeholderLabel.text = viewModel.data.placeholder
        }
    }

    // MARK: - Actions

    @objc private func saveBtnTapped() {
        print("call api")
    }

}

// MARK: - UITextViewDelegate
extension ProfileAddSummaryVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let viewModel else { return false }
        if text == "\n" { // For 'Done' keyboard key
            textView.resignFirstResponder()
            return false
        }

        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let shouldChangeText = newText.count <= viewModel.data.charsLimit
        if shouldChangeText {
            limitLabel.text = "\(newText.count)/\(viewModel.data.charsLimit)"
        }
        // Enable navigationBarRightItem when current chars are not .zero
        navigationItem.rightBarButtonItem?.isEnabled = newText.count > .zero ? true : false
        return shouldChangeText
    }
}
