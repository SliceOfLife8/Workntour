//
//  CreateOpportunityVC.swift
//  workntour
//
//  Created by Chris Petimezas on 27/6/22.
//

import UIKit
import SharedKit
import CommonUI
import DropDown
import EasyTipView

/// This class is not fully localized.
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
    @IBOutlet weak var workingDaysButton: UIButton!
    @IBOutlet weak var languagesRequiredTextField: GradientTextField!
    @IBOutlet weak var accommodationsTextField: GradientTextField!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var learningOpportunitesLabel: UILabel!
    @IBOutlet weak var learningOpportunitesTextField: GradientTextField!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var breakfastBtn: Checkbox!
    @IBOutlet weak var lunchBtn: Checkbox!
    @IBOutlet weak var dinnerBtn: Checkbox!
    @IBOutlet weak var useSharedKitchenBtn: Checkbox!
    @IBOutlet weak var additionalButton: PrimaryButton!

    // MARK: - Constructors/Destructors

    deinit {
        progressBar.removeFromSuperview()
    }

    // MARK: - LifeCycle

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
        accommodationsTextField.gradientDelegate = self
        learningOpportunitesTextField.gradientDelegate = self
    }

    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
        guard let mode = viewModel?.dataModel.mode else { return }

        setupNavigationBar(mainTitle: "create_opportunity_title".localized())
        navigationItem.largeTitleDisplayMode = .never

        switch mode {
        case .create:
            let createIcon = UIBarButtonItem(
                title: "create".localized(),
                style: .plain,
                target: self,
                action: #selector(createActionTapped)
            )
            navigationItem.rightBarButtonItems = [createIcon]
            navigationItem.rightBarButtonItem?.isEnabled = false
        case .edit:
            let bar = UIBarButtonItem(
                image: UIImage(systemName: "ellipsis.circle"),
                style: .plain,
                target: self,
                action: nil
            )
            self.navigationItem.rightBarButtonItem = bar
            self.navigationItem.rightBarButtonItem?.menu = addMenuItemsToBarItem()
        }
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

        progressBar.isHidden = false
        guard let createButton = navigationItem.rightBarButtonItem,
              case .create = viewModel?.dataModel.mode
        else {
            return
        }
        easyTipView?.show(forItem: createButton)
    }

    override func setupUI() {
        super.setupUI()
        guard let viewModel else { return }

        secondaryStackView.setCustomSpacing(32, after: typeOfHelpTextField)
        secondaryStackView.setCustomSpacing(32, after: addressLabel)
        secondaryStackView.setCustomSpacing(32, after: datesLabel)
        secondaryStackView.setCustomSpacing(32, after: workingDaysButton)
        secondaryStackView.setCustomSpacing(16, after: languagesRequiredTextField)
        thirdStackView.setCustomSpacing(24, after: learningOpportunitesLabel)

        workingDaysButton.imageView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        breakfastBtn.isChecked = viewModel.meals.contains(.breakfast)
        lunchBtn.isChecked = viewModel.meals.contains(.lunch)
        dinnerBtn.isChecked = viewModel.meals.contains(.dinner)
        useSharedKitchenBtn.isChecked = viewModel.meals.contains(.useSharedKitchen)

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
        guard let viewModel else { return }

        categoryTextField.configure(
            placeHolder: "category_placeholder".localized(),
            text: viewModel.opportunityModel?.category.value,
            type: .opportunityCategory
        )
        jobTitleTextView.text = viewModel.opportunityModel?.title
        jobDescriptionTextView.text = viewModel.opportunityModel?.description
        typeOfHelpTextField.configure(
            placeHolder: "type_of_help_placeholder".localized(),
            text: viewModel.opportunityModel?.typeOfHelp.map { $0.value }.joined(separator: ","),
            type: .typeOfHelp,
            fontSize: 12
        )
        languagesRequiredTextField.configure(
            placeHolder: "languages_required_placeholder".localized(),
            text: viewModel.opportunityModel?.languagesRequired.map { $0.value }.joined(separator: ","),
            type: .languagesRequired,
            fontSize: 14
        )
        accommodationsTextField.configure(
            placeHolder: "accomodations_placeholder".localized(),
            text: viewModel.opportunityModel?.accommodation.value,
            type: .accommodation
        )
        learningOpportunitesTextField.configure(
            placeHolder: "learning_opportunities_placeholder".localized(),
            text: viewModel.opportunityModel?.learningOpportunities.map { $0.value }.joined(separator: ","),
            type: .learningOpportunities,
            fontSize: 12
        )

        easyTipView = EasyTipView(
            text: "create_opportunity_popup_info".localized(with: String(Int(viewModel.NUM_OF_REQUIRED_FIELDS))),
            preferences: preferences
        )
        let imagesInfoAttributedText = addBoldText(
            fullString: "create_opportunity_images_info".localized() as NSString,
            boldPartsOfString: ["create_opportunity_images_info_bold".localized() as NSString],
            font: UIFont.scriptFont(.regular, size: 16),
            boldFont: UIFont.scriptFont(.bold, size: 16)
        )
        imagesInfoTipView = EasyTipView(text: imagesInfoAttributedText, preferences: preferences)
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$progress
            .sink(receiveValue: { [weak self] value in
                self?.progressBar.setProgress(value, animated: true)
                self?.navigationItem.rightBarButtonItem?.isEnabled = round(value) == 1.0 ? true : false
            })
            .store(in: &storage)

        viewModel?.$images
            .sink(receiveValue: { [weak self] images in
                self?.collectionViewDescription.isHidden = images.count > 0 ? true : false
                self?.imagesCollectionView.reloadData()
            })
            .store(in: &storage)

        viewModel?.$location
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] location in
                self?.addressLabel.text = location.placemark?.formattedName(userIsHost: true)
            })
            .store(in: &storage)

        viewModel?.$dates
            .compactMap { $0.first }
            .sink(receiveValue: { [weak self] dates in
                if let from = dates.start, let to = dates.end {
                    self?.datesLabel.text = "\(from) - \(to)"
                }
            })
            .store(in: &storage)

        viewModel?.$workingDays
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.workingDaysButton.imageView?.transform = .identity
            })
            .store(in: &storage)

        viewModel?.$validData
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] valid in
                if valid {
                    self?.showActionAlertAfterValidation()
                } else {
                    self?.coordinator?.navigate(
                        to: .state(.showAlert(
                            title: "Your input data seems to be invalid!",
                            subtitle: "Please check them again"
                        ))
                    )
                }
            })
            .store(in: &storage)

        viewModel?.$opportunityCreated
            .dropFirst()
            .sink(receiveValue: { [weak self] status in
                if status {
                    self?.coordinator?.navigate(to: .updateOpportunitiesOnLanding)
                } else {
                    self?.coordinator?.navigate(
                        to: .state(.showAlert(
                            title: "Something went wrong!",
                            subtitle: "Please try again"
                        ))
                    )
                }
            })
            .store(in: &storage)

        viewModel?.$opportunityUpdated
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator?.navigate(to: .updateOpportunitiesOnLanding)
            })
            .store(in: &storage)

        viewModel?.$opportunityDeleted
            .dropFirst()
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator?.navigate(to: .updateOpportunitiesOnLanding)
            })
            .store(in: &storage)
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

    private func addBoldText(
        fullString: NSString,
        boldPartsOfString: [NSString],
        font: UIFont,
        boldFont: UIFont
    ) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.appColor(.extraLightGray)]
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: UIColor.appColor(.lightGray)]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes: nonBoldFontAttribute)

        boldPartsOfString.forEach { part in
            boldString.addAttributes(boldFontAttribute,
                                     range: fullString.range(of: part as String))
        }

        return boldString
    }

    private func showActionAlertAfterValidation() {
        AlertHelper.showAlertWithTwoActions(
            self,
            title: "Your input data seems to be valid",
            message: "Would you like to proceed?",
            leftButtonTitle: "Discard changes!",
            leftButtonStyle: .destructive,
            rightButtonTitle: "Yes",
            leftAction: {
                self.coordinator?.navigate(to: .state(.back))
            },
            rightAction: {
                self.viewModel?.createOpportunity()
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        )
    }

    private func addMenuItemsToBarItem() -> UIMenu {
        let updateAction = UIAction(title: "save".localized()) { [weak self] _ in
            self?.viewModel?.updateOpportunity()
        }

        let deleteAction = UIAction(
            title: "delete".localized(),
            image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal),
            handler: { [weak self] _ in
                self?.viewModel?.deleteOpportunity()
            })

        return UIMenu(
            title: "Quick actions",
            options: .displayInline,
            children: [updateAction, deleteAction]
        )
    }

    // MARK: - Actions

    @objc private func createActionTapped() {
        viewModel?.validateData()
    }

    @IBAction func imagesInfoAction(_ sender: Any) {
        imagesInfoTipView?.show(forView: infoBtn)
    }

    @IBAction func openGalleryAction(_ sender: Any) {
        coordinator?.navigate(to: .openGalleryPicker)
    }

    @IBAction func openMapActionTapped(_ sender: Any) {
        coordinator?.navigate(to: .showMap)
    }

    @IBAction func openCalendarAction(_ sender: Any) {
        coordinator?.navigate(to: .openCalendar)
    }

    @IBAction func workingDaysTapped(_ sender: Any) {
        coordinator?.navigate(to: .selectWorkingDaysHours(dates: viewModel?.workingDays))
    }

    @IBAction func additionalButtonTapped(_ sender: Any) {
        coordinator?.navigate(to: .createOpportunityAddOptionals(viewModel?.additonalOfferings))
    }
}
