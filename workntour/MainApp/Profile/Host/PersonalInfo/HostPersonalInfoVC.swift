//
//  HostPersonalInfoVC.swift
//  workntour
//
//  Created by Chris Petimezas on 30/11/22.
//

import UIKit
import CommonUI
import DropDown

class HostPersonalInfoVC: BaseVC<HostPersonalInfoViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameTextField: GradientTextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var surnameTextField: GradientTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: GradientTextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: GradientTextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: GradientTextField!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var postalCodeTextField: GradientTextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: GradientTextField!
    @IBOutlet weak var mobileNumLabel: UILabel!
    @IBOutlet weak var mobileNumTextField: GradientTextField!
    @IBOutlet weak var fixedNumber: UILabel!
    @IBOutlet weak var fixedNumberTextField: GradientTextField!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var vatTextField: GradientTextField!

    // MARK: - Properties

    private var plainTextFields: [UITextField?] = []

    private lazy var countriesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = viewModel?.countries.models.compactMap { $0.flag } ?? []

        dropDown.cellNib = UINib(nibName: "CountriesDropDownCell", bundle: nil)

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CountriesDropDownCell else { return }

            // Setup your custom UI components
            let model = self.viewModel?.countries.models.filter { $0.flag == item }.first

            cell.configure(
                flag: model?.flag,
                name: model?.name,
                prefix: model?.regionCode
            )
        }

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            guard let model = viewModel?.countries.models.filter({ $0.flag == item }).first
            else {
                return
            }

            viewModel?.updateSelectedCountry(model: model, index: index)

            mobileNumTextField.changeFlag(countryFlag: model.flag, regionCode: model.regionCode)
            mobileNumTextField.placeholder = "+\(model.regionCode) xxxxxxxxxx"
            mobileNumTextField.text?.removeAll()
        }

        return dropDown
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
        hideKeyboardWhenTappedAround()
        nameTextField.gradientDelegate = self
        surnameTextField.gradientDelegate = self
        addressTextField.gradientDelegate = self
        cityTextField.gradientDelegate = self
        postalCodeTextField.gradientDelegate = self
        countryTextField.gradientDelegate = self
        mobileNumTextField.gradientDelegate = self
        fixedNumberTextField.gradientDelegate = self
        vatTextField.gradientDelegate = self

        plainTextFields = [
            nameTextField,
            surnameTextField,
            nil,
            addressTextField,
            cityTextField,
            postalCodeTextField,
            countryTextField
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(mainTitle: "edit_info".localized())
        let saveAction = UIBarButtonItem(
            title: "save".localized(),
            style: .plain,
            target: self,
            action: #selector(saveBtnTapped)
        )
        navigationItem.rightBarButtonItems = [saveAction]
    }

    override func setupUI() {
        super.setupUI()
        guard let mode = viewModel?.data.mode else { return }

        if case .company(let profile) = mode {
            setupCompanyUI(profile)
        } else if case .individual(let profile) = mode {
            setupIndividualUI(profile)
        }
    }

    // MARK: - Private Methods

    private func setupCompanyUI(_ data: CompanyHostProfileDto) {
        guard let viewModel else { return }
        nameLabel.text = "Company Name"
        nameTextField.configure(
            placeHolder: "name_placeholder".localized(),
            text: data.name,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: nameTextField)

        emailLabel.text = "email".localized()
        emailTextField.configure(
            placeHolder: "email_placeholder".localized(),
            text: data.email,
            type: .email
        )
        mainStackView.setCustomSpacing(16, after: emailTextField)

        addressLabel.text = "address".localized()
        addressTextField.configure(
            placeHolder: "address_placeholder".localized(),
            text: "FIX ME",
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: addressTextField)

        cityLabel.text = "city".localized()
        cityTextField.configure(
            placeHolder: "city_placeholder".localized(),
            text: "FIX ME",
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: cityTextField)

        postalCodeLabel.text = "postal_code".localized()
        postalCodeTextField.configure(
            placeHolder: "postal_code_placeholder".localized(),
            text: data.postalAddress,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: postalCodeTextField)

        countryLabel.text = "country".localized()
        countryTextField.configure(
            placeHolder: "country_placeholder".localized(),
            text: data.country,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: countryTextField)

        mobileNumLabel.text = "mobile_num".localized()
        mobileNumTextField.configure(
            placeHolder: "+\(viewModel.countryPrefix) xxxxxxxxxx",
            text: data.mobile,
            countryFlag: viewModel.countryFlag,
            regionCode: viewModel.countryPrefix,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: mobileNumTextField)

        fixedNumber.text = "Fixed Number"
        fixedNumberTextField.configure(
            placeHolder: "Enter your Fixed number",
            text: data.fixedNumber,
            type: .phone
        )
        mainStackView.setCustomSpacing(16, after: fixedNumberTextField)

        vatLabel.text = "VAT Number"
        vatTextField.configure(
            placeHolder: "Enter your VAT number",
            text: "FIX ME",
            type: .vatNumber
        )
        mainStackView.setCustomSpacing(16, after: vatTextField)

        surnameLabel.isHidden = true
        surnameTextField.isHidden = true
    }

    private func setupIndividualUI(_ data: IndividualHostProfileDto) {
        guard let viewModel else { return }
        nameLabel.text = "name".localized()
        nameTextField.configure(
            placeHolder: "name_placeholder".localized(),
            text: data.name,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: nameTextField)

        surnameLabel.text = "surname".localized()
        surnameTextField.configure(
            placeHolder: "surname_placeholder".localized(),
            text: data.surname,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: surnameTextField)

        emailLabel.text = "email".localized()
        emailTextField.configure(
            placeHolder: "email_placeholder".localized(),
            text: data.email,
            type: .email
        )
        mainStackView.setCustomSpacing(16, after: emailTextField)

        addressLabel.text = "address".localized()
        addressTextField.configure(
            placeHolder: "address_placeholder".localized(),
            text: "FIX ME",
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: addressTextField)

        cityLabel.text = "city".localized()
        cityTextField.configure(
            placeHolder: "city_placeholder".localized(),
            text: "FIX ME",
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: cityTextField)

        postalCodeLabel.text = "postal_code".localized()
        postalCodeTextField.configure(
            placeHolder: "postal_code_placeholder".localized(),
            text: data.postalAddress,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: postalCodeTextField)

        countryLabel.text = "country".localized()
        countryTextField.configure(
            placeHolder: "country_placeholder".localized(),
            text: data.country,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: countryTextField)

        mobileNumLabel.text = "mobile_num".localized()
        mobileNumTextField.configure(
            placeHolder: "+\(viewModel.countryPrefix) xxxxxxxxxx",
            text: data.mobile,
            countryFlag: viewModel.countryFlag,
            regionCode: viewModel.countryPrefix,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: mobileNumTextField)

        fixedNumber.isHidden = true
        fixedNumberTextField.isHidden = true
        vatLabel.isHidden = true
        vatTextField.isHidden = true
    }

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

    // MARK: - Actions

    @objc private func saveBtnTapped() {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let email = emailTextField.text,
              !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !surname.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            self.coordinator?.navigate(to: .state(.showAlert(title: "missing_mandatory_fields".localized(),
                                                             subtitle: nil)))
            return
        }

        viewModel?.updatePersonalInfo(
            name: name,
            surname: surname,
            address: addressTextField.text,
            city: cityTextField.text,
            postalCode: postalCodeTextField.text,
            country: countryTextField.text,
            mobileNum: mobileNumTextField.text,
            fixedNum: fixedNumberTextField.text,
            vatNum: vatTextField.text
        )

        guard let mode = viewModel?.data.mode else { return }

        if case .company(let profile) = mode {
            self.coordinator?.navigate(to: .updateCompanyProfile(profile))
        } else if case .individual(let profile) = mode {
            self.coordinator?.navigate(to: .updateIndividualProfile(profile))
        }
    }
}

// MARK: - Keyboard Observers
extension HostPersonalInfoVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: - GradientTFDelegate
extension HostPersonalInfoVC: GradientTFDelegate {

    func didCountryFlagTapped() {
        countriesDropDown.anchorView = mobileNumTextField
        if let index = viewModel?.countries.countrySelectedIndex {
            countriesDropDown.selectRow(index)
        }
        countriesDropDown.show()
    }

    func shouldReturn(_ textField: UITextField) {
        guard let nextValidTextField = plainTextFields.item(after: textField) as? UITextField
        else {
            view.endEditing(true)
            return
        }

        nextValidTextField.becomeFirstResponder()
    }
}
