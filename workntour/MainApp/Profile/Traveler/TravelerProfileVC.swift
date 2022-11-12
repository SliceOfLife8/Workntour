//
//  TravelerProfileVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 15/6/22.
//

import UIKit
import SharedKit
import CommonUI
import DropDown
import KDCircularProgress
import MaterialComponents.MaterialChips

class TravelerProfileVC: BaseVC<TravelerProfileViewModel, ProfileCoordinator> {

    private lazy var nationalitiesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["American", "British", "Greek"]
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            nationalityTextField.text = item
            self.viewModel?.traveler?.nationality = item
            nationalityTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            nationalityTextField.arrowTapped()
        }

        return dropDown
    }()

    private lazy var typeOfTravelerDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = TravelerType.allCases.map { $0.value }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            typeOfTraveler.text = item
            self.viewModel?.traveler?.type = TravelerType(caseName: item)
            typeOfTraveler.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            typeOfTraveler.arrowTapped()
        }

        return dropDown
    }()

    private lazy var countriesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = viewModel!.countries.models.compactMap { $0.flag }
        dropDown.dismissMode = .onTap

        dropDown.cellNib = UINib(nibName: "CountriesDropDownCell", bundle: nil)

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CountriesDropDownCell else { return }

            // Setup your custom UI components
            let model = self.viewModel?.countries.models.filter { $0.flag == item }.first
            cell.configure(flag: model?.flag, name: model?.name, prefix: model?.regionCode)
        }

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            guard let model = self.viewModel?.countries.models.filter({ $0.flag == item }).first else {
                return
            }

            self.viewModel?.updateSelectedCountry(model: model, index: index)

            mobileNumTextField.changeFlag(countryFlag: model.flag, regionCode: model.regionCode)
            mobileNumTextField.placeholder = "+\(model.regionCode) xxxxxxxxxx"
            mobileNumTextField.text?.removeAll()
        }

        return dropDown
    }()

    private lazy var saveButton: MDCChipView = {
        let chipView = MDCChipView()
        chipView.titleLabel.text = "Save"
        chipView.titleFont = UIFont.scriptFont(.bold, size: 16)
        chipView.setBackgroundColor(UIColor.appColor(.lavender), for: .normal)
        chipView.setTitleColor(UIColor.appColor(.badgeBg), for: .normal)
        chipView.addTarget(self, action: #selector(saveActionTapped), for: .touchUpInside)
        return chipView
    }()

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressBar: KDCircularProgress!
    @IBOutlet weak var travelerIcon: UIImageView!
    @IBOutlet weak var percentBtn: GradientButton!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var travelerChip: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    // MARK: - TextFields
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameTextField: GradientTextField!
    @IBOutlet weak var surnameTextField: GradientTextField!
    @IBOutlet weak var nationalityTextField: GradientTextField!
    @IBOutlet weak var ageTextField: GradientTextField!
    @IBOutlet weak var emailTextField: GradientTextField!
    @IBOutlet weak var postalAddressTextField: GradientTextField!
    @IBOutlet weak var mobileNumTextField: GradientTextField!
    @IBOutlet weak var typeOfTraveler: GradientTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
        hideKeyboardWhenTappedAround()
        scrollView.delegate = self
        nationalityTextField.gradientDelegate = self
        ageTextField.gradientDelegate = self
        postalAddressTextField.gradientDelegate = self
        typeOfTraveler.gradientDelegate = self
        mobileNumTextField.gradientDelegate = self
    }

    override func setupTexts() {
        super.setupTexts()

        fullnameLabel.text = viewModel?.traveler?.fullname
        infoLabel.text = "Don’t be shy! Workntour is all about getting to know new people, so please introduce yourself to us and to your potential hosts!"
        let introPart = "Don’t be shy!"
        infoLabel.changeFont(ofText: introPart, with: UIFont.scriptFont(.bold, size: 16))
        infoLabel.changeTextColor(ofText: introPart, with: UIColor.appColor(.lavender))
    }

    private func setupTextFields() {
        nameTextField.configure(placeHolder: "Enter your name",
                                text: viewModel?.traveler?.name,
                                type: .name)
        mainStackView.setCustomSpacing(16, after: nameTextField)

        surnameTextField.configure(placeHolder: "Enter your surname",
                                   text: viewModel?.traveler?.surname,
                                   type: .surname)
        mainStackView.setCustomSpacing(16, after: surnameTextField)

        nationalityTextField.configure(placeHolder: "Select your nationality",
                                       text: viewModel?.traveler?.nationality,
                                       type: .nationality)
        mainStackView.setCustomSpacing(16, after: nationalityTextField)

        ageTextField.configure(placeHolder: "Enter your age",
                               text: viewModel?.traveler?.birthday,
                               type: .age)
        mainStackView.setCustomSpacing(16, after: ageTextField)

        emailTextField.configure(placeHolder: "Enter your email",
                                 text: viewModel?.traveler?.email,
                                 type: .email)
        mainStackView.setCustomSpacing(16, after: emailTextField)

        let countryPrefix = viewModel?.traveler?.countryCode ?? (viewModel?.countries.selectedCountryPrefix ?? "30")
        let countryFlag = Countries.countryPrefixes.key(from: countryPrefix)?.countryFlag()

        mobileNumTextField.configure(placeHolder: "+\(countryPrefix) xxxxxxxxxx",
                                     text: viewModel?.traveler?.mobile,
                                     countryFlag: countryFlag,
                                     regionCode: countryPrefix,
                                     type: .phone)
        mainStackView.setCustomSpacing(16, after: mobileNumTextField)

        postalAddressTextField.configure(placeHolder: "Enter your postal address",
                                         text: viewModel?.traveler?.postalAddress,
                                         type: .name)
        mainStackView.setCustomSpacing(16, after: postalAddressTextField)

        typeOfTraveler.configure(placeHolder: "Select your type",
                                 text: viewModel?.traveler?.type?.value,
                                 type: .travelerType)
        mainStackView.setCustomSpacing(16, after: typeOfTraveler)
    }

    override func setupUI() {
        super.setupUI()

        view.addSubview(saveButton)
        travelerChip.layer.cornerRadius = 12
        infoLabel.setLineHeight(lineHeight: 1.33)
        setupTextFields()

        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.snp.bottom).offset(-16)
            $0.width.equalTo(64)
            $0.height.equalTo(64)
        }
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$newImage
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] data in
                self?.travelerIcon.image = UIImage(data: data)
            })
            .store(in: &storage)

        viewModel?.$traveler
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] traveler in
                self?.percentBtn.isHidden = true
                let percents = traveler.percents

                self?.progressBar.animate(fromAngle: 0, toAngle: percents._360, duration: percents.duration, completion: { _ in
                    self?.percentBtn.setTitle("\(percents._100)% Complete", for: .normal)
                    self?.percentBtn.isHidden = false
                })
            })
            .store(in: &storage)

        viewModel?.$profileUpdated
            .dropFirst()
            .sink(receiveValue: { [weak self] status in
                let message = status ? "Your profile has been successfully updated!" : "Something went wrong!\nPlease try again"
                self?.coordinator?.navigate(to: .state(.showAlert(title: "",
                                                                  subtitle: message)))
            })
            .store(in: &storage)
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Actions
    @IBAction func uploadImageTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .selectSkills(preselectedSkills: [.bartending]))
    }

    @objc private func saveActionTapped() {
        self.viewModel?.updateProfile(age: ageTextField.text,
                                      postalAddress: postalAddressTextField.text,
                                      mobileNum: mobileNumTextField.text)
    }
}

// MARK: - Gradient TF Delegates
extension TravelerProfileVC: GradientTFDelegate {

    func notEditableTextFieldTriggered(_ textField: UITextField) {
        if textField == nationalityTextField {
            nationalitiesDropDown.anchorView = textField
            nationalitiesDropDown.show()
        } else {
            typeOfTravelerDropDown.anchorView = textField
            typeOfTravelerDropDown.show()
        }
    }

    func didCountryFlagTapped() {
        countriesDropDown.anchorView = mobileNumTextField
        if let index = viewModel?.countries.countrySelectedIndex {
            countriesDropDown.selectRow(index)
        }
        countriesDropDown.show()
    }

    func shouldReturn(_ textField: UITextField) {
        view.endEditing(true)
    }
}

// MARK: - Keyboard HostProfileVC
extension TravelerProfileVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: - ScrollView Delegates
extension TravelerProfileVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.25) {
            self.saveButton.alpha = 0
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.25) {
            self.saveButton.alpha = 1
        }
    }
}
