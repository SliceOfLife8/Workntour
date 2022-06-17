//
//  RegistrationTravelerVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/5/22.
//

import UIKit
import SharedKit
import CommonUI
import CombineDataSources
import DropDown
import NVActivityIndicatorView

class RegistrationTravelerVC: BaseVC<RegistrationTravelerViewModel, RegistrationCoordinator> {
    // MARK: - Vars
    private var signUpButton: PrimaryButton = {
        let button = PrimaryButton()
        button.radius = 8
        button.enabledStateColor = UIColor.appColor(.lavender)
        return button
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

            let cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? RegistrationCell
            cell?.gradientTextField.changeFlag(countryFlag: model.flag, regionCode: model.regionCode)

            cell?.gradientTextField.placeholder = "+\(model.regionCode) xxxxxxxxxx"
            cell?.gradientTextField.text?.removeAll()
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
            let nationalitiesCell = tableView.visibleCells.suffix(2).first as? RegistrationCell
            nationalitiesCell?.gradientTextField.text = item
            self.viewModel?.cellsValues[.nationality] = item
            nationalitiesCell?.gradientTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            let nationalitiesCell = tableView.visibleCells.suffix(2).first as? RegistrationCell
            nationalitiesCell?.gradientTextField.arrowTapped()
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
            let sexCell = tableView.visibleCells.last as? RegistrationCell
            sexCell?.gradientTextField.text = item
            self.viewModel?.cellsValues[.sex] = item
            sexCell?.gradientTextField.arrowTapped()
        }

        dropDown.cancelAction = { [unowned self] in
            let sexCell = tableView.visibleCells.last as? RegistrationCell
            sexCell?.gradientTextField.arrowTapped()
        }

        return dropDown
    }()

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        registerNotifications()
        customizeDropDown()

        self.viewModel?.fetchModels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableViewFooter()
    }

    override func bindViews() {
        super.bindViews()
        viewModel?.$data
            .bind(subscriber:
                    tableView.rowsSubscriber(cellIdentifier:
                                                RegistrationCell.identifier,
                                             cellType: RegistrationCell.self,
                                             cellConfig: { [weak self] (cell, _, model) in
                cell.setupCell(title: model.title,
                               isRequired: model.isRequired,
                               isOptionalLabelVisible: model.optionalTextVisible,
                               placeholder: model.placeholder,
                               text: self?.viewModel?.cellsValues[model.type].flatMap { $0 },
                               type: model.type,
                               countryFlag: model.countryEmoji,
                               regionCode: model.countryPrefixCode,
                               description: model.description,
                               error: self?.viewModel?.pullOfErrors[model.type]?.flatMap { $0 }?.description)

                DispatchQueue.main.async {
                    cell.roundCorners()
                }
                cell.delegate = self
            }))
            .store(in: &storage)

        viewModel?.$loaderVisibility
            .sink { [weak self] status in
                if status {
                    self?.showLoader()
                } else {
                    self?.stopLoader()
                }
            }
            .store(in: &storage)

        viewModel?.$errorMessage
            .dropFirst()
            .sink(receiveValue: { [weak self] error in
                if let errorDescription = error {
                    self?.coordinator?.navigate(to: .errorDialog(description: errorDescription))
                }
            })
            .store(in: &storage)

        viewModel?.$signUpCompleted
            .sink(receiveValue: { [weak self] value in
                if let email = value {
                    self?.coordinator?.navigate(to: .emailVerification(email: email))
                }
            })
            .store(in: &storage)
    }

    // MARK: - Actions
    @objc private func closeBtnTapped() {
        self.coordinator?.navigate(to: .close)
    }

    @objc private func signUpTapped() {
        self.view.endEditing(true) // Important step!
        let hasErrors = viewModel?.verifyRequiredFields()

        if hasErrors == true {
            for (index, element) in viewModel!.pullOfErrors {
                var cell: RegistrationCell?

                switch index {
                case .name:
                    cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegistrationCell
                case .surname:
                    cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? RegistrationCell
                case .email:
                    cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? RegistrationCell
                case .password:
                    cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? RegistrationCell
                case .verifyPassword:
                    cell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? RegistrationCell
                case .age:
                    cell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? RegistrationCell
                case .phone:
                    cell = tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? RegistrationCell
                default: break
                }

                cell?.gradientTextField.errorOccured = true
                cell?.showError(element?.description)
                tableView.beginUpdates()
                tableView.endUpdates()
                cell?.gradientTextField.removeGradientLayers()
            }
        } else {
            viewModel?.registerTraveler()
        }
    }

}

// MARK: - Basic setup
private extension RegistrationTravelerVC {
    private func setupNavBar() {
        self.setupNavigationBar(mainTitle: "Sign up")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTapped))
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: RegistrationCell.identifier, bundle: Bundle(for: RegistrationCell.self)), forCellReuseIdentifier: RegistrationCell.identifier)
        tableView.keyboardDismissMode = .interactive
    }

    private func setupTableViewFooter() {
        let footerView = UIView(frame: CGRect(origin: .zero,
                                              size: CGSize(width: tableView.frame.size.width, height: 96)))
        signUpButton.addExclusiveConstraints(superview: footerView,
                                             top: (footerView.topAnchor, 24),
                                             bottom: (footerView.bottomAnchor, 24),
                                             left: (footerView.leadingAnchor, 24),
                                             right: (footerView.trailingAnchor, 24),
                                             height: 48)
        signUpButton.addTarget(self,
                               action: #selector(signUpTapped),
                               for: .touchUpInside)
        signUpButton.setTitle("Sign Up", for: .normal)
        tableView.tableFooterView = footerView
    }

    private func customizeDropDown() {
        let appearance = DropDown.appearance()

        appearance.selectionBackgroundColor = UIColor.appColor(.lavender).withAlphaComponent(0.2)
        appearance.textFont = UIFont.scriptFont(.regular, size: 16)
        appearance.textColor = UIColor.appColor(.floatingLabel)
        appearance.cornerRadius = 8
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
    }
}

// MARK: - RegistrationCellDelegate
extension RegistrationTravelerVC: RegistrationCellDelegate {
    func textFieldDidBeginEditing(cell: RegistrationCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let type = cell.gradientTextField.type else {
            return
        }

        viewModel?.pullOfErrors[type] = nil

        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    /// Switching between textFields on pressing return key
    func textFieldShouldReturn(cell: RegistrationCell) {
        guard let currentIndexPath = tableView.indexPath(for: cell) else {
            return
        }

        var nextIndexPath = currentIndexPath
        nextIndexPath.row += 1
        /// Check if next indexPath exists
        if tableView.hasRowAtIndexPath(indexPath: nextIndexPath) {
            let nextCell = tableView.cellForRow(at: nextIndexPath) as? RegistrationCell
            /// Remove the keyboard when next textField has an arrow as rightView (f.e. up_arrow)
            if nextCell?.gradientTextField.rightIcon?.oneOf(other: .upArrow, .downArrow) == true {
                cell.gradientTextField.resignFirstResponder()
            } else { /// Set the keyboard
                nextCell?.gradientTextField.becomeFirstResponder()
            }
        }
    }

    func textFieldDidChange(cell: RegistrationCell) {
        guard let type = cell.gradientTextField.type else {
            return
        }
        // Update new value of text
        viewModel?.cellsValues[type] = cell.gradientTextField.text?.trimmingCharacters(in: .whitespaces)
        // Restore errorView
        cell.gradientTextField.errorOccured = false
        cell.showError(nil)
        tableView.beginUpdates() // Update height of cells
        tableView.endUpdates()
        cell.gradientTextField.removeGradientLayers()
    }

    func showCountryFlags(cell: RegistrationCell) {
        countriesDropDown.anchorView = cell
        if let index = viewModel?.countries.countrySelectedIndex {
            countriesDropDown.selectRow(index)
        }
        countriesDropDown.show()
    }

    func showDropdownList(cell: RegistrationCell) {
        if tableView.visibleCells.last == cell {
            sexDropDown.anchorView = cell
            sexDropDown.show()
        } else {
            nationalitiesDropDown.anchorView = cell
            nationalitiesDropDown.show()
        }
    }
}

// MARK: - Keyboard Notifications
extension RegistrationTravelerVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        tableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: Notification) {
        tableView.contentInset.bottom = 0
    }
}
