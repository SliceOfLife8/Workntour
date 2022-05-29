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

class RegistrationVC: BaseVC<RegistrationViewModel, RegistrationCoordinator> {

    // MARK: - Vars
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

        self.viewModel?.fetchModels()
    }

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

    override func bindViews() {
        viewModel?.data
            .bind(subscriber:
                    tableView.rowsSubscriber(cellIdentifier:
                                                RegistrationCell.identifier,
                                             cellType: RegistrationCell.self,
                                             cellConfig: { cell, _, model in
                cell.setupCell(title: model.title,
                               isOptional: model.isOptional,
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

}

// MARK: - RegistrationCellDelegate
extension RegistrationVC: RegistrationCellDelegate {
    func textFieldDidBeginEditing(cell: RegistrationCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
