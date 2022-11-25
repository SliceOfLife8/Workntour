//
//  HostProfileVC.swift
//  workntour
//
//  Created by Chris Petimezas on 19/6/22.
//

import UIKit
import SharedKit
import CommonUI
import DropDown
import KDCircularProgress
import MaterialComponents.MaterialChips

class HostProfileVC: BaseVC<HostProfileViewModel, ProfileCoordinator> {

    private lazy var countriesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = viewModel!.countries.models.compactMap { $0.flag }
        dropDown.dismissMode = .onTap

        dropDown.cellNib = UINib(nibName: "CountriesDropDownCell", bundle: nil)

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CountriesDropDownCell else { return }

            // Setup your custom UI components
            let model = self.viewModel?.countries.models.filter { $0.flag == item }.first
            cell.configure(flag: model?.flag, name: model?.name, prefix: nil)
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            guard let model = self.viewModel?.countries.models.filter({ $0.flag == item }).first else {
                return
            }

            let country = model.name
            countryTextField.text = country

            if self.viewModel?.isCompany == true {
                self.viewModel?.companyHost?.country = country
            } else {
                self.viewModel?.individualHost?.country = country
            }

            countryTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            countryTextField.arrowTapped()
        }

        return dropDown
    }()

    private lazy var mobileCountriesDropDown: DropDown = {
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

            mobileTextField.changeFlag(countryFlag: model.flag, regionCode: model.regionCode)
            mobileTextField.placeholder = "+\(model.regionCode) xxxxxxxxxx"
            mobileTextField.text?.removeAll()
        }

        return dropDown
    }()

    private lazy var nationalitiesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["American", "British", "Greek"]
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            nationalityTextField.text = item
            self.viewModel?.individualHost?.nationality = item
            nationalityTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            nationalityTextField.arrowTapped()
        }

        return dropDown
    }()

    private lazy var sexDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = UserSex.allCases.map { $0.rawValue }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            sexTextField.text = item
            self.viewModel?.individualHost?.sex = UserSex(rawValue: item)
            sexTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            sexTextField.arrowTapped()
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
    @IBOutlet weak var hostIcon: UIImageView!
    @IBOutlet weak var percentBtn: GradientButton!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var hostTypeChip: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    // MARK: - TextFields
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var emailTextField: GradientTextField!
    @IBOutlet weak var postalAddressTextField: GradientTextField!
    @IBOutlet weak var countryTextField: GradientTextField!
    @IBOutlet weak var mobileTextField: GradientTextField!
    @IBOutlet weak var fixedNumTextField: GradientTextField!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var nationalityTextField: GradientTextField!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sexTextField: GradientTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
        hideKeyboardWhenTappedAround()
        scrollView.delegate = self
        postalAddressTextField.gradientDelegate = self
        countryTextField.gradientDelegate = self
        mobileTextField.gradientDelegate = self
        fixedNumTextField.gradientDelegate = self
        nationalityTextField.gradientDelegate = self
        sexTextField.gradientDelegate = self
    }

    override func setupTexts() {
        super.setupTexts()

        hostName.text = (viewModel?.isCompany == true) ? viewModel?.companyHost?.name : viewModel?.individualHost?.fullname
        hostTypeChip.setTitle(viewModel?.isCompany == true ? "Company" : "Individual", for: .normal)
        // swiftlint:disable line_length
        introLabel.text = "Introduce yourself to us, so that we can go ahead and promote the opportunities that you have to offer. Please indicate what type of host you are and tell us about your project or business to help us understand your needs."
        let introPart = "Introduce yourself to us,"
        introLabel.changeFont(ofText: introPart, with: UIFont.scriptFont(.bold, size: 16))
        introLabel.changeTextColor(ofText: introPart, with: UIColor.appColor(.lavender))
    }

    private func setupTextFields() {
        let emailValue = (viewModel?.isCompany == true) ? viewModel?.companyHost?.email : viewModel?.individualHost?.email
        emailTextField.configure(placeHolder: "Enter your email",
                                 text: emailValue,
                                 type: .email)
        emailTextField.isUserInteractionEnabled = false
        emailTextField.backgroundColor = UIColor.appColor(.gray).withAlphaComponent(0.2)
        mainStackView.setCustomSpacing(16, after: emailTextField)

        let postalAddressValue = (viewModel?.isCompany == true) ? viewModel?.companyHost?.postalAddress : viewModel?.individualHost?.postalAddress
        postalAddressTextField.configure(placeHolder: "Enter your postal address",
                                         text: postalAddressValue,
                                         type: .name)
        mainStackView.setCustomSpacing(16, after: postalAddressTextField)

        let countryValue = (viewModel?.isCompany == true) ? viewModel?.companyHost?.country : viewModel?.individualHost?.country
        countryTextField.configure(placeHolder: "Select your country",
                                   text: countryValue,
                                   type: .nationality)
        mainStackView.setCustomSpacing(16, after: countryTextField)

        let mobileNumValue = (viewModel?.isCompany == true) ? viewModel?.companyHost?.mobile : viewModel?.individualHost?.mobile
        let countryCode = (viewModel?.isCompany == true) ? viewModel?.companyHost?.countryCode : viewModel?.individualHost?.countryCode

        let countryPrefix = countryCode ?? (viewModel?.countries.selectedCountryPrefix ?? "30")
        let countryFlag = Countries.countryPrefixes.key(from: countryPrefix)?.countryFlag()

        mobileTextField.configure(placeHolder: "+\(countryPrefix) xxxxxxxxxx",
                                  text: mobileNumValue,
                                  countryFlag: countryFlag,
                                  regionCode: countryPrefix,
                                  type: .phone)
        mainStackView.setCustomSpacing(16, after: mobileTextField)

        let fixedNumValue = (viewModel?.isCompany == true) ? viewModel?.companyHost?.fixedNumber : viewModel?.individualHost?.fixedNumber
        fixedNumTextField.configure(placeHolder: "Enter your fixed number",
                                    text: fixedNumValue,
                                    type: .phone)
        mainStackView.setCustomSpacing(16, after: fixedNumTextField)

        if viewModel?.isCompany == false {
            nationalityLabel.isHidden = false
            nationalityTextField.isHidden = false
            nationalityTextField.configure(placeHolder: "Select your nationality",
                                           text: viewModel?.individualHost?.nationality,
                                           type: .nationality)
            mainStackView.setCustomSpacing(16, after: fixedNumTextField)
        }
    }

    override func setupUI() {
        super.setupUI()

        view.addSubview(saveButton)
        hostTypeChip.layer.cornerRadius = 12
        introLabel.setLineHeight(lineHeight: 1.33)
        setupTextFields()
        viewModel?.newImage = (viewModel?.isCompany == true) ? viewModel?.companyHost?.profileImage : viewModel?.individualHost?.image

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
                self?.hostIcon.image = UIImage(data: data)
            })
            .store(in: &storage)

        viewModel?.$companyHost
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] company in
                self?.percentBtn.isHidden = true
                let percents = company.percents

                self?.progressBar.animate(fromAngle: 0, toAngle: percents._360, duration: percents.duration, completion: { _ in
                    self?.percentBtn.setTitle("\(percents._100)% Complete", for: .normal)
                    self?.percentBtn.isHidden = false
                })
            })
            .store(in: &storage)

        viewModel?.$individualHost
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] individual in
                self?.percentBtn.isHidden = true
                let percents = individual.percents

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
        self.coordinator?.navigate(to: .openGalleryPicker)
    }

    @objc private func saveActionTapped() {
        self.viewModel?.updateProfile(postalAddress: postalAddressTextField.text,
                                      mobileNum: mobileTextField.text,
                                      fixedNumber: fixedNumTextField.text)
    }

}

// MARK: - Gradient TF Delegates
extension HostProfileVC: GradientTFDelegate {

    func notEditableTextFieldTriggered(_ textField: UITextField) {
        if textField == countryTextField {
            countriesDropDown.anchorView = textField
            countriesDropDown.show()
        } else if textField == nationalityTextField {
            nationalitiesDropDown.anchorView = textField
            nationalitiesDropDown.show()
        } else {
            sexDropDown.anchorView = textField
            sexDropDown.show()
        }
    }

    func didCountryFlagTapped() {
        mobileCountriesDropDown.anchorView = mobileTextField
        if let index = viewModel?.countries.countrySelectedIndex {
            mobileCountriesDropDown.selectRow(index)
        }
        mobileCountriesDropDown.show()
    }

    func shouldReturn(_ textField: UITextField) {
        view.endEditing(true)
    }

}

// MARK: - Keyboard HostProfileVC
extension HostProfileVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: - ScrollView Delegates
extension HostProfileVC: UIScrollViewDelegate {
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
