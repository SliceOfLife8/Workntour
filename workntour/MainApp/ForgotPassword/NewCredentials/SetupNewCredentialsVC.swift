//
//  SetupNewCredentialsVC.swift
//  workntour
//
//  Created by Chris Petimezas on 9/1/23.
//

import UIKit
import CommonUI
import BottomSheet

// MARK: - SetupNewCredentialsVC
class SetupNewCredentialsVC: BaseVC<SetupNewCredentialsViewModel, AppCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var mainScrollView: UIScrollView!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "new_creds".localized()
        }
    }

    @IBOutlet weak var passwordSizeValidationLabel: UILabel! {
        didSet {
            passwordSizeValidationLabel.text = "password_size_validation".localized()
        }
    }

    @IBOutlet weak var passwordSizeValidationIcon: UIImageView!

    @IBOutlet weak var passwordUpperCaseValidationLabel: UILabel! {
        didSet {
            passwordUpperCaseValidationLabel.text = "password_upper_case_validation".localized()
        }
    }

    @IBOutlet weak var passwordUpperCaseValidationIcon: UIImageView!

    @IBOutlet weak var passwordLowerCaseValidationLabel: UILabel! {
        didSet {
            passwordLowerCaseValidationLabel.text = "password_lower_case_validation".localized()
        }
    }

    @IBOutlet weak var passwordLowerCaseValidationIcon: UIImageView!

    @IBOutlet weak var passwordNumAndSpecialCharValidationLabel: UILabel! {
        didSet {
            passwordNumAndSpecialCharValidationLabel.text = "password_num_special_char_validation".localized()
        }
    }

    @IBOutlet weak var passwordNumAndSpecialCharValidationIcon: UIImageView!

    @IBOutlet weak var newPasswordLabel: UILabel! {
        didSet {
            newPasswordLabel.text = "new_password".localized()
        }
    }

    @IBOutlet weak var newPasswordTextField: GradientTextField! {
        didSet {
            newPasswordTextField.configure(
                placeHolder: "new_password_placeholder".localized(),
                type: .password
            )
            newPasswordTextField.gradientDelegate = self
            newPasswordTextField.addTarget(
                self,
                action: #selector(newPasswordTextFieldHasChanged(_:)),
                for: .editingChanged
            )
        }
    }

    @IBOutlet weak var confirmPasswordLabel: UILabel! {
        didSet {
            confirmPasswordLabel.text = "retype_password".localized()
        }
    }

    @IBOutlet weak var confirmPasswordTextField: GradientTextField! {
        didSet {
            confirmPasswordTextField.configure(
                placeHolder: "retype_password_placeholder".localized(),
                type: .verifyPassword
            )
            confirmPasswordTextField.gradientDelegate = self
            confirmPasswordTextField.addTarget(
                self,
                action: #selector(confirmPasswordTextFieldHasChanged(_:)),
                for: .editingChanged
            )
        }
    }

    @IBOutlet weak var submitButton: PrimaryButton! {
        didSet {
            submitButton.setTitle(
                "submit".localized(),
                for: .normal
            )
        }
    }

    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle(
                "cancel".localized(),
                for: .normal
            )
        }
    }

    // MARK: - Properties

    private var keyboardHeight: CGFloat = 0

    private var keyboardHasAppearedAtLeastOnce: Bool = false

    // MARK: - Constructors/Destructors

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotifications()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        estimateHeight()
    }

    override func bindViews() {
        viewModel?.validatePasswords
            .map { status in
                guard status,
                      self.newPasswordTextField.text == self.confirmPasswordTextField.text
                else {
                    return false
                }
                return true
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &storage)

        viewModel?.$passwordLengthIsValid
            .sink(receiveValue: { value in
                if value {
                    self.passwordSizeValidationIcon.isHidden = false
                    self.passwordSizeValidationLabel.font = UIFont.scriptFont(.bold, size: 14)
                }
                else {
                    self.passwordSizeValidationIcon.isHidden = true
                    self.passwordSizeValidationLabel.font = UIFont.scriptFont(.medium, size: 14)
                }
            })
            .store(in: &storage)

        viewModel?.$passwordContainsUpperCaseLetter
            .sink(receiveValue: { value in
                if value {
                    self.passwordUpperCaseValidationIcon.isHidden = false
                    self.passwordUpperCaseValidationLabel.font = UIFont.scriptFont(.bold, size: 14)
                }
                else {
                    self.passwordUpperCaseValidationIcon.isHidden = true
                    self.passwordUpperCaseValidationLabel.font = UIFont.scriptFont(.medium, size: 14)
                }
            })
            .store(in: &storage)

        viewModel?.$passwordContainsLowerCaseLetter
            .sink(receiveValue: { value in
                if value {
                    self.passwordLowerCaseValidationIcon.isHidden = false
                    self.passwordLowerCaseValidationLabel.font = UIFont.scriptFont(.bold, size: 14)
                }
                else {
                    self.passwordLowerCaseValidationIcon.isHidden = true
                    self.passwordLowerCaseValidationLabel.font = UIFont.scriptFont(.medium, size: 14)
                }
            })
            .store(in: &storage)

        viewModel?.$passwordContainsNumAndSpecialChar
            .sink(receiveValue: { value in
                if value {
                    self.passwordNumAndSpecialCharValidationIcon.isHidden = false
                    self.passwordNumAndSpecialCharValidationLabel.font = UIFont.scriptFont(.bold, size: 14)
                }
                else {
                    self.passwordNumAndSpecialCharValidationIcon.isHidden = true
                    self.passwordNumAndSpecialCharValidationLabel.font = UIFont.scriptFont(.medium, size: 14)
                }
            })
            .store(in: &storage)

        viewModel?.$passwordChanged
            .dropFirst()
            .sink(receiveValue: { value in
                self.dismiss(
                    animated: true,
                    completion: { [weak self] in
                        self?.showGenericBottomSheet(withStatus: value)
                    })
            })
            .store(in: &storage)
    }

    // MARK: - Private Methods

    private func estimateHeight() {
        UIView.animate(
            withDuration: keyboardHasAppearedAtLeastOnce ? 0.25 : 0,
            delay: 0
        ) { [unowned self] in
            self.preferredContentSize = CGSize(
                width: mainScrollView.frame.width,
                height: 460 + keyboardHeight
            )
        }
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

    // MARK: - Navigation -- Show BottomSheet

    private func showGenericBottomSheet(withStatus status: Bool) {
        guard let mainCoordinator = coordinator?.childCoordinators.first as? MainCoordinator else { return }
        let loginIsPresented = mainCoordinator.rootViewController.topViewController is LoginVC

        var dataModel: GenericBottomSheetVC.DataModel

        if status {
            dataModel = GenericBottomSheetVC.DataModel(
                title: "password_updated".localized(),
                description: "password_updated_description".localized(),
                buttonText: "login".localized(),
                buttonAction: {
                    if !loginIsPresented {
                        mainCoordinator.navigate(to: .login)
                    }
                }
            )
        }
        else {
            dataModel = GenericBottomSheetVC.DataModel(
                title: "password_not_updated".localized(),
                description: "password_not_updated_description".localized(),
                buttonText: "OK"
            )
        }

        let bottomSheetVC = GenericBottomSheetVC(dataModel: dataModel)

        mainCoordinator.rootViewController.presentBottomSheet(
            viewController: bottomSheetVC,
            configuration: BottomSheetConfiguration(
                cornerRadius: 16,
                pullBarConfiguration: .visible(.init(height: 20)),
                shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
            )
        )
    }

    // MARK: - Actions

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let passwordText = newPasswordTextField.text else { return }
        viewModel?.updateCredentials(passwordText)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @objc func newPasswordTextFieldHasChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel?.passwordValidation(text)
    }

    @objc func confirmPasswordTextFieldHasChanged(_ textField: UITextField) {
        guard let passwordText = newPasswordTextField.text else { return }
        viewModel?.passwordValidation(passwordText)
    }
}

// MARK: - Keyboard Notifications
extension SetupNewCredentialsVC {
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardHeight = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        mainScrollView.contentInset.bottom = keyboardHeight
        keyboardHasAppearedAtLeastOnce = true
        view.setNeedsLayout()
    }

    @objc private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
        mainScrollView.contentInset.bottom = 0
        view.setNeedsLayout()
    }
}

// MARK: - GradientTFDelegate
extension SetupNewCredentialsVC: GradientTFDelegate {

    func shouldReturn(_ textField: UITextField) {
        if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
    }
}
