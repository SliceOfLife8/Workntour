//
//  TravelerPersonalInfoVC.swift
//  workntour
//
//  Created by Chris Petimezas on 16/11/22.
//

import UIKit
import CommonUI
import SharedKit
import DropDown

class TravelerPersonalInfoVC: BaseVC<TravelerPersonalInfoViewModel, ProfileCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: GradientTextField!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var surnameTextField: GradientTextField!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var nationalityTextField: GradientTextField!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageTextField: GradientTextField!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var sexTextField: GradientTextField!
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

    // MARK: - Properties

    private var plainTextFields: [UITextField?] = []

    private lazy var nationalitiesDropDown: DropDown = {
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
                prefix: nil
            )
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            let country = viewModel?.countries.models.filter { $0.flag == item }.first?.name
            nationalityTextField.text = country
            self.viewModel?.data.profile.nationality = country
            nationalityTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            nationalityTextField.arrowTapped()
        }

        return dropDown
    }()

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

    private lazy var sexDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = UserSex.allCases.map { $0.value }

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            sexTextField.text = item
            viewModel?.data.profile.sex = UserSex(caseName: item)
            nationalityTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            sexTextField.arrowTapped()
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
        nationalityTextField.gradientDelegate = self
        ageTextField.gradientDelegate = self
        sexTextField.gradientDelegate = self
        addressTextField.gradientDelegate = self
        cityTextField.gradientDelegate = self
        postalCodeTextField.gradientDelegate = self
        countryTextField.gradientDelegate = self
        mobileNumTextField.gradientDelegate = self

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

    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()

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

        guard let viewModel else { return }
        let data = viewModel.data.profile

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

        nationalityTextField.text = "nationality".localized()
        nationalityTextField.configure(
            placeHolder: "nationality_placeholder".localized(),
            text: data.nationality,
            type: .noEditable
        )
        mainStackView.setCustomSpacing(16, after: nationalityTextField)

        ageLabel.text = "age".localized()
        ageTextField.configure(
            placeHolder: "age_placeholder".localized(),
            text: data.birthday,
            type: .date
        )
        mainStackView.setCustomSpacing(16, after: ageTextField)

        sexLabel.text = "sex".localized()
        sexTextField.configure(
            placeHolder: "sex_placeholder".localized(),
            text: data.sex?.value,
            type: .noEditable
        )
        mainStackView.setCustomSpacing(16, after: sexTextField)

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
            text: data.address,
            type: .plain
        )
        mainStackView.setCustomSpacing(16, after: addressTextField)

        cityLabel.text = "city".localized()
        cityTextField.configure(
            placeHolder: "city_placeholder".localized(),
            text: data.city,
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
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$updateProfileDto
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] profile in
                self?.coordinator?.navigate(to: .updateTravelerProfile(profile))
            })
            .store(in: &storage)
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
            age: ageTextField.text,
            email: email,
            address: addressTextField.text,
            city: cityTextField.text,
            postalCode: postalCodeTextField.text,
            country: countryTextField.text,
            mobileNum: mobileNumTextField.text
        )
    }
}

// MARK: - Keyboard Observers
extension TravelerPersonalInfoVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}

// MARK: - GradientTFDelegate
extension TravelerPersonalInfoVC: GradientTFDelegate {

    func notEditableTextFieldTriggered(_ textField: UITextField) {
        if textField == nationalityTextField {
            nationalitiesDropDown.anchorView = textField
            nationalitiesDropDown.show()
        } else if textField == sexTextField {
            sexDropDown.anchorView = textField
            sexDropDown.show()
        }
        view.endEditing(true)
    }

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
