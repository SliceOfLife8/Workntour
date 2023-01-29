//
//  HostSelectDaysVC.swift
//  workntour
//
//  Created by Chris Petimezas on 22/1/23.
//

import UIKit
import SharedKit
import CommonUI
import EasyTipView
import DropDown

class HostSelectDaysVC: BaseVC<HostSelectDaysViewModel, OpportunitiesCoordinator> {

    // MARK: - Properties

    private lazy var preferences: EasyTipView.Preferences = {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.scriptFont(.bold, size: 14)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = UIColor.appColor(.purple)
        preferences.drawing.arrowPosition = .top
        return preferences
    }()

    private var easyTipView: EasyTipView?

    private lazy var daysPerWeekDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = Array(1...6).map { String($0) }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            let emojiText: String
            switch item {
            case "1": emojiText = "1️⃣"
            case "2": emojiText = "2️⃣"
            case "3": emojiText = "3️⃣"
            case "4": emojiText = "4️⃣"
            case "5": emojiText = "5️⃣"
            case "6": emojiText = "6️⃣"
            default: emojiText = item
            }

            cell.optionLabel.text = emojiText
            cell.optionLabel.textAlignment = .center
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            daysOffTextField.arrowTapped()
            daysOffTextField.text = item
            self.viewModel?.daysOff = Int(item)
        }

        dropDown.cancelAction = { [unowned self] in
            daysOffTextField.arrowTapped()
        }

        return dropDown
    }()

    // MARK: - Outlets

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var travelersStayLabel: UILabel!
    @IBOutlet weak var daysLengthLabel: UILabel!
    @IBOutlet weak var stayAtLeastLabel: UILabel!
    @IBOutlet weak var stayAtLeastTextField: GradientTextField!
    @IBOutlet weak var stayNoMoreLabel: UILabel!
    @IBOutlet weak var stayNoMoreTextField: GradientTextField!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var workingHoursLengthLabel: UILabel!
    @IBOutlet weak var workingHoursTextField: GradientTextField!
    @IBOutlet weak var daysOffsLabel: UILabel!
    @IBOutlet weak var daysOffLengthLabel: UILabel!
    @IBOutlet weak var daysOffTextField: GradientTextField!

    // MARK: - LifeCycle

    override func setupUI() {
        super.setupUI()
        guard let viewModel else { return }

        navigationItem.setTitle(
            title: "create_opportunity_setup_days_title".localized(),
            subtitle: "create_opportunity_setup_days_subtitle".localized()
        )
        let addIcon = UIBarButtonItem(
            title: "navigation_item_add".localized(),
            style: .plain,
            target: self,
            action: #selector(setupDaysTapped)
        )
        navigationItem.rightBarButtonItems = [addIcon]
        hideKeyboardWhenTappedAround()

        mainStackView.setCustomSpacing(14, after: daysLengthLabel)
        mainStackView.setCustomSpacing(16, after: stayAtLeastTextField)
        mainStackView.setCustomSpacing(16, after: stayNoMoreTextField)
        mainStackView.setCustomSpacing(16, after: workingHoursTextField)
        stayAtLeastTextField.configure(
            placeHolder: "minimum_num_of_days".localized(),
            text: viewModel.minimumDays != nil ? String(viewModel.minimumDays!) : nil,
            type: .num
        )
        stayNoMoreTextField.configure(
            placeHolder: "maximum_num_of_days".localized(),
            text: viewModel.maximumDays != nil ? String(viewModel.maximumDays!) : nil,
            type: .num
        )
        workingHoursTextField.configure(
            placeHolder: "maximum_hours".localized(),
            text: viewModel.maxWorkingHours != nil ? String(viewModel.maxWorkingHours!) : nil,
            type: .num
        )
        daysOffTextField.configure(
            placeHolder: "days_off".localized(),
            text: viewModel.daysOff != nil ? String(viewModel.daysOff!) : nil,
            type: .noEditable
        )
        daysOffTextField.gradientDelegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        easyTipView?.dismiss()
        easyTipView = nil
    }

    override func bindViews() {
        super.bindViews()
        guard let addIcon = navigationItem.rightBarButtonItem else { return }

        viewModel?.validateData
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: addIcon)
            .store(in: &storage)

        viewModel?.$maxWorkingHours
            .compactMap { $0 }
            .map { $0 > 32 } // limit: 32 hours/week
            .sink(receiveValue: { [weak self] value in
                if value {
                    self?.workingHoursTextField.text = "32"
                }
            })
            .store(in: &storage)
    }

    // MARK: - Actions

    @IBAction func lengthOfStayInfoButtonTapped(_ sender: UIButton) {
        easyTipView?.dismiss()
        easyTipView = EasyTipView(
            text: "length_of_stay_info".localized(),
            preferences: preferences
        )
        easyTipView?.show(forView: sender)
    }

    @IBAction func workingHoursInfoButtonTapped(_ sender: UIButton) {
        easyTipView?.dismiss()
        easyTipView = EasyTipView(
            text: "working_hours_info".localized(),
            preferences: preferences
        )
        easyTipView?.show(forView: sender)
    }

    @IBAction func daysOffInfoButtonTapped(_ sender: UIButton) {
        easyTipView?.dismiss()
        easyTipView = EasyTipView(
            text: "days_off_info".localized(),
            preferences: preferences
        )
        easyTipView?.show(forView: sender)
    }

    @IBAction func stayAtLeastTextFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel?.minimumDays = Int(text)
    }

    @IBAction func stayNoMoreTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel?.maximumDays = Int(text)
    }

    @IBAction func workingHoursTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        viewModel?.maxWorkingHours = Int(text)
    }

    @objc func setupDaysTapped() {
        guard let viewModel,
              let minDays = viewModel.minimumDays,
              let maxDays = viewModel.maximumDays,
              let workingHours = viewModel.maxWorkingHours,
              let daysOff = viewModel.daysOff
        else {
            return
        }

        coordinator?.setupDays(
            minDays: minDays,
            maxDays: maxDays,
            workingHours: workingHours,
            daysOff: daysOff
        )
    }
}

// MARK: -
extension HostSelectDaysVC: GradientTFDelegate {

    func shouldReturn(_ textField: UITextField) {}

    func notEditableTextFieldTriggered(_ textField: UITextField) {
        view.endEditing(true)
        daysPerWeekDropDown.anchorView = textField
        daysPerWeekDropDown.show()
    }
}
