//
//  HostDescriptionVC.swift
//  workntour
//
//  Created by Chris Petimezas on 1/12/22.
//

import UIKit
import CommonUI
import SharedKit

class HostDescriptionVC: BaseVC<HostDescriptionViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.layer.borderColor = UIColor.appColor(.purple).cgColor
            mainView.layer.borderWidth = 1
            mainView.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.dataDetectorTypes = .link
            textView.returnKeyType = .done
            textView.delegate = self
        }
    }

    @IBOutlet weak var limitLabel: UILabel!

    @IBOutlet weak var placeholderLabel: UILabel!

    @IBOutlet weak var linkButton: PrimaryButton!

    // MARK: - Life Cycle

    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()

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
            textView.text = currentText
        }
        else {
            placeholderLabel.text = viewModel.data.placeholder
        }

        let linkText = viewModel.data.link ?? "insert_link".localized()
        linkButton.setTitle(linkText, for: .normal)
    }

    // MARK: - Actions

    @objc private func saveBtnTapped() {
        let description = textView.text.trimmingCharacters(in: .whitespaces)
        var linkText: String? = nil

        if let text = linkButton.titleLabel?.text,
           text != "insert_link".localized() {
            linkText = text
        }

        if var companyDto = UserDataManager.shared.retrieve(CompanyHostProfileDto.self) {
            companyDto.description = description
            companyDto.link = linkText
            self.coordinator?.navigate(to: .updateCompanyProfile(companyDto))
        }
        else if var individualDto = UserDataManager.shared.retrieve(IndividualHostProfileDto.self) {
            individualDto.description = description
            //individualDto.link = text
            self.coordinator?.navigate(to: .updateIndividualProfile(individualDto))
        }
    }

    @IBAction func linkBtnTapped(_ sender: Any) {
        let alertController = UIAlertController(
            title: "",
            message: "insert_link_here".localized(),
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = "www.google.com"
            textField.text = self.viewModel?.data.link
        }

        let okAction = UIAlertAction(
            title: "OK",
            style: .default) { [weak alertController] _ in
                guard let textField = alertController?.textFields?.first,
                      let text = textField.text,
                      text.validURL
                else {
                    return
                }

                self.linkButton.setTitle(text, for: .normal)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }

        alertController.addAction(okAction)

        self.present(alertController, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension HostDescriptionVC: UITextViewDelegate {

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
