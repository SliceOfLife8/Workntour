//
//  CreateOpportunityVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 27/6/22.
//

import UIKit
import SharedKit
import CommonUI
import DropDown
import EasyTipView

class CreateOpportunityVC: BaseVC<CreateOpportunityViewModel, OpportunitiesCoordinator> {

    // MARK: - Vars
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.progressTintColor = UIColor.appColor(.mint)
        return progressBar
    }()

    private lazy var preferences: EasyTipView.Preferences = {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont.scriptFont(.bold, size: 14)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = UIColor.appColor(.purple)
        preferences.drawing.arrowPosition = .top
        return preferences
    }()

    var easyTipView: EasyTipView?
    var imagesInfoTipView: EasyTipView?

    lazy var categoriesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = OpportunityCategory.allCases.map { $0.value }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            categoryTextField.arrowTapped()
            categoryTextField.text = item
            viewModel?.category = OpportunityCategory(caseName: item)
        }

        dropDown.cancelAction = { [unowned self] in
            categoryTextField.arrowTapped()
        }

        return dropDown
    }()

    lazy var typeOfHelpDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = TypeOfHelp.allCases.map { $0.value }

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.multiSelectionAction = { [unowned self] (_, items: [String]) in
            typeOfHelpTextField.text = items.map { $0 }.joined(separator: ",")
            viewModel?.typeOfHelp = items.compactMap { TypeOfHelp(caseName: $0) }
        }

        dropDown.cancelAction = { [unowned self] in
            typeOfHelpTextField.arrowTapped()
        }

        return dropDown
    }()

    lazy var languagesRequiredDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = Language.allCases.map { $0.value }

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.multiSelectionAction = { [unowned self] (_, items: [String]) in
            languagesRequiredTextField.text = items.map { $0 }.joined(separator: ",")
            viewModel?.languagesRequired = items.compactMap { Language(caseName: $0) }
        }

        dropDown.cancelAction = { [unowned self] in
            languagesRequiredTextField.arrowTapped()
        }

        return dropDown
    }()

    lazy var languagesSpokenDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = Language.allCases.map { $0.value }

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.multiSelectionAction = { [unowned self] (_, items: [String]) in
            languagesSpokenTextField.text = items.map { $0 }.joined(separator: ",")
            viewModel?.languagesSpoken = items.compactMap { Language(caseName: $0) }
        }

        dropDown.cancelAction = { [unowned self] in
            languagesSpokenTextField.arrowTapped()
        }

        return dropDown
    }()

    lazy var accommodationsDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = Accommodation.allCases.map { $0.value }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            accommodationsTextField.arrowTapped()
            accommodationsTextField.text = item
            viewModel?.accommodation = Accommodation(caseName: item)
        }

        dropDown.cancelAction = { [unowned self] in
            accommodationsTextField.arrowTapped()
        }

        return dropDown
    }()

    lazy var learningOpportunitiesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = LearningOpportunities.allCases.map { $0.value }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.multiSelectionAction = { [unowned self] (_, items: [String]) in
            learningOpportunitesTextField.text = items.map { $0 }.joined(separator: ",")
            viewModel?.learningOpportunities = items.compactMap { LearningOpportunities(caseName: $0) }
        }

        dropDown.cancelAction = { [unowned self] in
            learningOpportunitesTextField.arrowTapped()
        }

        return dropDown
    }()

    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var jobTitleTextView: UITextView!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var categoryTextField: GradientTextField!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewDescription: UILabel!
    @IBOutlet weak var typeOfHelpTextField: GradientTextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var secondaryStackView: UIStackView!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var workingsDayStackView: UIStackView!
    @IBOutlet weak var languagesSpokenTextField: GradientTextField!
    @IBOutlet weak var languagesRequiredTextField: GradientTextField!
    @IBOutlet weak var accommodationsTextField: GradientTextField!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var learningOpportunitesLabel: UILabel!
    @IBOutlet weak var learningOpportunitesTextField: GradientTextField!
    @IBOutlet weak var minDays: UITextField!
    @IBOutlet weak var maxDays: UITextField!
    @IBOutlet weak var workingHours: UITextField!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var breakfastBtn: Checkbox!
    @IBOutlet weak var lunchBtn: Checkbox!
    @IBOutlet weak var dinnerBtn: Checkbox!
    @IBOutlet weak var useSharedKitchenBtn: Checkbox!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        customizeDropDown()
        hideKeyboardWhenTappedAround()
        scrollView.delegate = self
        jobTitleTextView.delegate = self
        jobDescriptionTextView.delegate = self
        breakfastBtn.delegate = self
        lunchBtn.delegate = self
        dinnerBtn.delegate = self
        useSharedKitchenBtn.delegate = self
        categoryTextField.gradientDelegate = self
        typeOfHelpTextField.gradientDelegate = self
        languagesRequiredTextField.gradientDelegate = self
        languagesSpokenTextField.gradientDelegate = self
        accommodationsTextField.gradientDelegate = self
        learningOpportunitesTextField.gradientDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        minDays.setGradientLayer(borderWidth: 1)
        maxDays.setGradientLayer(borderWidth: 1)
        workingHours.setGradientLayer(borderWidth: 1)
    }

    override func setupUI() {
        super.setupUI()

        let createIcon = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createActionTapped))
        navigationItem.rightBarButtonItems = [createIcon]
        navigationItem.rightBarButtonItem?.isEnabled = false

        secondaryStackView.setCustomSpacing(32, after: typeOfHelpTextField)
        secondaryStackView.setCustomSpacing(32, after: addressLabel)
        secondaryStackView.setCustomSpacing(32, after: datesLabel)
        secondaryStackView.setCustomSpacing(32, after: workingsDayStackView)
        secondaryStackView.setCustomSpacing(16, after: languagesRequiredTextField)
        secondaryStackView.setCustomSpacing(24, after: languagesSpokenTextField)
        thirdStackView.setCustomSpacing(24, after: learningOpportunitesLabel)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(progressBar)
            progressBar.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-1)
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.easyTipView?.dismiss()
        }
    }

    override func setupTexts() {
        super.setupTexts()

        categoryTextField.configure(placeHolder: "Select your category", type: .opportunityCategory)
        typeOfHelpTextField.configure(placeHolder: "Select your preferences for a perfect traveler", type: .typeOfHelp, fontSize: 12)
        languagesRequiredTextField.configure(placeHolder: "Add required languages needed", type: .languagesRequired, fontSize: 14)
        languagesSpokenTextField.configure(placeHolder: "Add languages spoken on your accommodation", type: .languagesSpoken, fontSize: 14)
        accommodationsTextField.configure(placeHolder: "Select accommodation type", type: .accommodation)
        learningOpportunitesTextField.configure(placeHolder: "Select learning opportunities", type: .learningOpportunities, fontSize: 12)
        minDays.attributedPlaceholder = NSAttributedString(string: "7. Min Days", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.placeholder)])
        maxDays.attributedPlaceholder = NSAttributedString(string: "8. Max Days", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.placeholder)])
        workingHours.attributedPlaceholder = NSAttributedString(string: "9. Total Hours", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.placeholder)])

        easyTipView = EasyTipView(text: "Please fill in all 13 required fields in order to activate Create button", preferences: preferences)
        // swiftlint:disable line_length
        let imagesInfoAttributedText = addBoldText(fullString: "The images you upload should be in high resolution. Like that your travelers will be willing to approach you! It is important to include photos of your property, the accommodation that you will be providing to travelers and anything else that will make your opportunity attractive to travelers. Please do not include pictures that show the name of your Business or Property, as they will be removed.", boldPartsOfString: ["Please do not include pictures that show the name of your Business or Property, as they will be removed."], font: UIFont.scriptFont(.regular, size: 16), boldFont: UIFont.scriptFont(.bold, size: 16))
        imagesInfoTipView = EasyTipView(text: imagesInfoAttributedText, preferences: preferences)
    }

    private func customizeDropDown() {
        let appearance = DropDown.appearance()

        appearance.selectionBackgroundColor = UIColor.appColor(.lavender).withAlphaComponent(0.2)
        appearance.textFont = UIFont.scriptFont(.regular, size: 16)
        appearance.textColor = UIColor.appColor(.floatingLabel)
        appearance.cornerRadius = 12
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "New Opportunity"
        navigationItem.largeTitleDisplayMode = .never
        progressBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        progressBar.isHidden = true
        easyTipView?.dismiss()
        imagesInfoTipView?.dismiss()
        easyTipView = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let createButton = self.navigationItem.rightBarButtonItem {
            self.easyTipView?.show(forItem: createButton)
        }
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$progress
            .sink(receiveValue: { [weak self] value in
                self?.progressBar.setProgress(value, animated: true)
                self?.navigationItem.rightBarButtonItem?.isEnabled = (value == 1.0) ? true : false
            })
            .store(in: &storage)

        viewModel?.$images
            .sink(receiveValue: { [weak self] images in
                self?.collectionViewDescription.isHidden = images.count > 0 ? true : false
                self?.imagesCollectionView.reloadData()
            })
            .store(in: &storage)

        viewModel?.$validData
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] valid in
                if valid {
                    self?.showActionAlertAfterValidation()
                } else {
                    self?.coordinator?.navigate(to: .showAlert(title: "Your input data seems to be invalid!", subtitle: "Please check them again"))
                }
            })
            .store(in: &storage)

        viewModel?.$opportunityIsCreated
            .dropFirst()
            .sink(receiveValue: { [weak self] status in
                if status {
                    self?.coordinator?.navigate(to: .updateOpportunitiesOnLanding)
                } else {
                    self?.coordinator?.navigate(to: .showAlert(title: "Something went wrong!", subtitle: "Please try again"))
                }
            })
            .store(in: &storage)
    }

    private func addBoldText(fullString: NSString,
                             boldPartsOfString: [NSString],
                             font: UIFont,
                             boldFont: UIFont) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.appColor(.extraLightGray)]
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: UIColor.appColor(.lightGray)]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes: nonBoldFontAttribute)

        boldPartsOfString.forEach { part in
            boldString.addAttributes(boldFontAttribute,
                                     range: fullString.range(of: part as String))
        }

        return boldString
    }

    func setupAddress(location: OpportunityLocation) {
        addressLabel.text = location.placemark?.formattedName()
        viewModel?.location = location
    }

    func setupAvailableDates(from: String, to: String) {
        datesLabel.text = "\(from) - \(to)"
        viewModel?.dates = [OpportunityDates(start: from, end: to)]
    }

    private func showActionAlertAfterValidation() {
        AlertHelper.showAlertWithTwoActions(self,
                                            title: "Your input data seems to be valid",
                                            message: "Would you like to proceed?",
                                            leftButtonTitle: "Discard changes!",
                                            leftButtonStyle: .destructive,
                                            rightButtonTitle: "Yes",
                                            leftAction: {
            self.coordinator?.navigate(to: .back)
        }, rightAction: {
            self.viewModel?.createOpportunity()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        })
    }

    // MARK: - Actions
    @objc private func createActionTapped() {
        self.viewModel?.validateData()
    }

    @IBAction func imagesInfoAction(_ sender: Any) {
        self.imagesInfoTipView?.show(forView: infoBtn)
    }

    @IBAction func openGalleryAction(_ sender: Any) {
        self.coordinator?.navigate(to: .openGalleryPicker)
    }

    @IBAction func openMapActionTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .showMap)
    }

    @IBAction func openCalendarAction(_ sender: Any) {
        self.coordinator?.navigate(to: .openCalendar)
    }

    // MARK: - Actions about textfields
    @IBAction func minDaysTextFieldChanged(_ sender: UITextField) {
        if let text = sender.text, let days = Int(text) {
            viewModel?.minDays = days
        } else {
            viewModel?.minDays = 0
        }
    }

    @IBAction func maxDaysTextFieldChanged(_ sender: UITextField) {
        if let text = sender.text, let days = Int(text) {
            viewModel?.maxDays = days
        } else {
            viewModel?.maxDays = 0
        }
    }

    @IBAction func totalHoursTextFieldChanged(_ sender: UITextField) {
        if let text = sender.text, let hours = Int(text) {
            viewModel?.totalHours = hours
        } else {
            viewModel?.totalHours = 0
        }
    }

    deinit {
        progressBar.removeFromSuperview()
    }
}
