//
//  ProfileExperienceVC.swift
//  workntour
//
//  Created by Chris Petimezas on 13/11/22.
//

import UIKit
import CommonUI
import SharedKit

class ProfileExperienceVC: BaseVC<ProfileExperienceViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var domainTextField: GradientTextField!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionTextField: GradientTextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDateTextField: GradientTextField!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDateTextField: GradientTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            descriptionTextView.layer.borderColor = UIColor.appColor(.purple).cgColor
            descriptionTextView.layer.borderWidth = 1
            descriptionTextView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var footerLabel: UILabel!

    // MARK: - Constructors/Destructors

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
        hideKeyboardWhenTappedAround()
        domainTextField.gradientDelegate = self
        positionTextField.gradientDelegate = self
        startDateTextField.gradientDelegate = self
        endDateTextField.gradientDelegate = self
        descriptionTextView.delegate = self
    }

    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
        guard let experience = viewModel?.data.experience else { return }

        setupNavigationBar(mainTitle: "experience".localized())

        if experience.isPrefilled {
            let bar = UIBarButtonItem(
                image: UIImage(systemName: "circle.grid.3x3"),
                style: .plain,
                target: self,
                action: nil
            )
            self.navigationItem.rightBarButtonItem = bar
            self.navigationItem.rightBarButtonItem?.menu = addMenuItemsToBarItem()
        }
        else {
            let saveAction = UIBarButtonItem(
                title: "save".localized(),
                style: .plain,
                target: self,
                action: #selector(saveBtnTapped)
            )
            navigationItem.rightBarButtonItems = [saveAction]
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func setupUI() {
        super.setupUI()

        guard let data = viewModel?.data else { return }

        switch data.experience.type {
        case .COMPANY:
            domainLabel.text = "company".localized()
            domainTextField.configure(
                placeHolder: "company_placeholder".localized(),
                text: data.experience.organization,
                type: .plain
            )
            segmentedControl.selectedSegmentIndex = 0
        case .UNIVERSITY:
            domainLabel.text = "university".localized()
            domainTextField.configure(
                placeHolder: "university_placeholder".localized(),
                text: data.experience.organization,
                type: .plain
            )
            segmentedControl.selectedSegmentIndex = 1
        }
        mainStackView.setCustomSpacing(16, after: domainTextField)

        positionLabel.text = "position".localized()
        positionTextField.configure(
            placeHolder: "position_placeholder".localized(),
            text: data.experience.position,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: positionTextField)

        startDateLabel.text = "start_date".localized()
        startDateTextField.configure(
            placeHolder: "select_date".localized(),
            text: data.experience.startDate,
            type: .date
        )
        mainStackView.setCustomSpacing(16, after: startDateTextField)

        endDateLabel.text = "end_date".localized()
        endDateTextField.configure(
            placeHolder: "select_date".localized(),
            text: data.experience.endDate,
            type: .date
        )
        mainStackView.setCustomSpacing(16, after: endDateTextField)

        descriptionLabel.text = "description".localized()
        descriptionTextView.text = data.experience.description
        mainStackView.setCustomSpacing(12, after: descriptionTextView)
        footerLabel.text = "experience_footer_desc".localized()

        guard data.experience.isPrefilled else { return }

        switch data.experience.type {
        case .COMPANY:
            segmentedControl.removeSegment(at: 1, animated: false)
        case .UNIVERSITY:
            segmentedControl.removeSegment(at: 0, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }

    // MARK: - Private Methods

    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func addMenuItemsToBarItem() -> UIMenu {
        // Create actions
        let updateAction = UIAction(
            title: "Update",
            image: UIImage(systemName: "pencil"),
            handler: { [weak self] _ in
                self?.saveBtnTapped()
            })

        let deleteAction = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal),
            handler: { [weak self] _ in
                self?.deleteBtnTapped()
            })

        return UIMenu(
            title: "",
            options: .displayInline,
            children: [updateAction, deleteAction]
        )
    }

    // MARK: - Actions

    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard let viewModel else { return }

        if sender.selectedSegmentIndex == 0 {
            viewModel.data.experience.type = .COMPANY
            domainLabel.text = "company".localized()
            domainTextField.configure(
                placeHolder: "company_placeholder".localized(),
                text: viewModel.data.experience.organization,
                type: .plain
            )
        }
        else {
            viewModel.data.experience.type = .UNIVERSITY
            domainLabel.text = "university".localized()
            domainTextField.configure(
                placeHolder: "university_placeholder".localized(),
                text: viewModel.data.experience.organization,
                type: .plain
            )
        }
    }

    @objc private func saveBtnTapped() {
        guard let viewModel,
              var profileDto = viewModel.traveler
        else {
            return
        }

        switch viewModel.data.mode {
        case .add:
            if profileDto.experience == nil {
                profileDto.experience = []
            }
            profileDto.experience?.append(viewModel.data.convertToExperience())
        case .edit:
            if let index = profileDto.experience?.firstIndex(where: { $0.uuid == viewModel.data.uuid }) {
                profileDto.experience?[index] = viewModel.data.convertToExperience()
            }
        }

        self.coordinator?.navigate(to: .updateTravelerProfile(profileDto))
    }

    private func deleteBtnTapped() {
        guard let viewModel,
              var profileDto = viewModel.traveler
        else {
            return
        }

        profileDto.experience = profileDto.experience?.filter { $0.uuid != viewModel.data.uuid }

        self.coordinator?.navigate(to: .updateTravelerProfile(profileDto))
    }

    @IBAction func domainDidChange(_ sender: UITextField) {
        guard let viewModel else { return }
        viewModel.data.experience.organization = sender.text
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.data.experience.isPrefilled ? true : false
    }

    @IBAction func positionDidChange(_ sender: UITextField) {
        guard let viewModel else { return }
        viewModel.data.experience.position = sender.text
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.data.experience.isPrefilled ? true : false
    }
    
    @IBAction func startDateDidEndEditing(_ sender: UITextField) {
        guard let viewModel else { return }
        viewModel.data.experience.startDate = sender.text?.changeDateFormat() // "2013-11-13"
    }

    @IBAction func endDateDidEndEditing(_ sender: UITextField) {
        guard let viewModel else { return }
        viewModel.data.experience.endDate = sender.text?.changeDateFormat()
    }

}

// MARK: - GradientTextFieldDelegate -- UITextViewDelegate
extension ProfileExperienceVC: GradientTFDelegate, UITextViewDelegate {
    func shouldReturn(_ textField: UITextField) {
        guard textField == domainTextField
        else {
            view.endEditing(true)
            return
        }
        positionTextField.becomeFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let viewModel else { return }
        viewModel.data.experience.description = textView.text
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.data.experience.isPrefilled ? true : false
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.scrollView.scrollToBottom()
        })
    }
}

// MARK: - Keyboard
extension ProfileExperienceVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}
