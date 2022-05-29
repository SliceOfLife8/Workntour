//
//  RegistrationVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 22/5/22.
//

import UIKit
import SharedKit
import CommonUI
import CombineDataSources
import DropDown

class RegistrationVC: BaseVC<RegistrationViewModel, RegistrationCoordinator> {
    // MARK: - Vars
    private var signUpButton: PrimaryButton = {
        let button = PrimaryButton()
        button.radius = 8
        button.enabledStateColor = UIColor.appColor(.lavender)
        return button
    }()

    private(set) var role: UserRole

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Init
    init(type: UserRole) {
        self.role = type
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        registerNotifications()

        self.viewModel?.input.send(())

        self.viewModel?.fetchCountryCodes()
        self.viewModel?.fetchModels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableViewFooter()
    }

    override func bindViews() {
        viewModel?.data
            .bind(subscriber:
                    tableView.rowsSubscriber(cellIdentifier:
                                                RegistrationCell.identifier,
                                             cellType: RegistrationCell.self,
                                             cellConfig: { cell, _, model in
                cell.setupCell(title: model.title,
                               isRequired: model.isRequired,
                               isOptionalLabelVisible: model.optionalTextVisible,
                               placeholder: model.placeholder,
                               keyboardType: model.textFieldKeyboardType,
                               rightIcon: model.textFieldRightIcon,
                               countryFlag: model.countryEmoji,
                               description: model.description)

                DispatchQueue.main.async {
                    cell.roundCorners()
                }
                cell.delegate = self
            }))
            .store(in: &storage)
    }

    @objc private func closeBtnTapped() {
        self.coordinator?.navigate(to: .close)
    }

    @objc private func signUpTapped() {
        print("talk to viewmodel!")
        /// Gather all textFields values and send them to viewModel for verification!
    }

}

// MARK: - Basic setup
private extension RegistrationVC {
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
}

// MARK: - RegistrationCellDelegate
extension RegistrationVC: RegistrationCellDelegate {
    func textFieldDidBeginEditing(cell: RegistrationCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

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
            /// Remove the keyboard when next textField has a rightView (f.e. up_arrow)
            if nextCell?.gradientTextField.rightView != nil {
                cell.gradientTextField.resignFirstResponder()
            } else { /// Set the keyboard
                nextCell?.gradientTextField.becomeFirstResponder()
            }
        }
    }
}

// MARK: - Keyboard Notifications
extension RegistrationVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        tableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height + 16
    }

    @objc private func keyboardWillHide(notification: Notification) {
        tableView.contentInset.bottom = 0
    }
}
