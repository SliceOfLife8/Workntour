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

class CreateOpportunityVC: BaseVC<CreateOpportunityViewModel, OpportunitiesCoordinator> {

    // MARK: - Vars
    private lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.progressTintColor = UIColor.appColor(.mint)
        return progressBar
    }()

    lazy var categoriesDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = OpportunityCategory.allCases.map { $0.rawValue }
        dropDown.dismissMode = .onTap

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.selectionAction = { [unowned self] (_, item: String) in
            categoryTextField.arrowTapped()
            categoryTextField.text = item
            viewModel?.category = OpportunityCategory(rawValue: item)
        }

        dropDown.cancelAction = { [unowned self] in
            categoryTextField.arrowTapped()
        }

        return dropDown
    }()

    lazy var typeOfHelpDropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = TypeOfHelp.allCases.map { $0.rawValue }

        dropDown.customCellConfiguration = { (_, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.text = item
        }

        dropDown.multiSelectionAction = { [unowned self] (_, items: [String]) in
            typeOfHelpTextField.text = items.map { $0 }.joined(separator: ",")
            viewModel?.typeOfHelp = items.compactMap { TypeOfHelp(rawValue: $0) }
        }

        dropDown.cancelAction = { [unowned self] in
            typeOfHelpTextField.arrowTapped()
        }

        return dropDown
    }()

    // MARK: - Outlets
    @IBOutlet weak var jobTitleTextView: UITextView!
    @IBOutlet weak var categoryTextField: GradientTextField!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var typeOfHelpTextField: GradientTextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var secondaryStackView: UIStackView!
    @IBOutlet weak var datesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        customizeDropDown()
        hideKeyboardWhenTappedAround()
        jobTitleTextView.delegate = self
        secondaryStackView.setCustomSpacing(32, after: typeOfHelpTextField)
        secondaryStackView.setCustomSpacing(32, after: addressLabel)
    }

    override func setupUI() {
        super.setupUI()

        let createIcon = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createActionTapped))
        navigationItem.rightBarButtonItems = [createIcon]
        navigationItem.rightBarButtonItem?.isEnabled = false

        categoryTextField.configure(placeHolder: "Select your category", type: .opportunityCategory)
        categoryTextField.gradientDelegate = self
        typeOfHelpTextField.configure(placeHolder: "Select your preferences for a perfect traveler", type: .typeOfHelp)
        typeOfHelpTextField.gradientDelegate = self

        if let navigationBar = navigationController?.navigationBar {
            progressBar.addExclusiveConstraints(superview: navigationBar, bottom: (navigationBar.bottomAnchor, 1), left: (navigationBar.leadingAnchor, 0), right: (navigationBar.trailingAnchor, 0))
        }
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

        setupNavigationBar(mainTitle: "New opportunity")
        progressBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        progressBar.isHidden = true
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$progress
            .sink(receiveValue: { [weak self] value in
                self?.progressBar.setProgress(value, animated: true)
            })
            .store(in: &storage)

        viewModel?.$images
            .sink(receiveValue: { [weak self] _ in
                self?.imagesCollectionView.reloadData()
            })
            .store(in: &storage)
    }

    func setupAddress(location: OpportunityLocation) {
        addressLabel.text = location.title
        viewModel?.location = location
    }

    func setupAvailableDates(from: String, to: String) {
        datesLabel.text = "\(from) - \(to)"
        viewModel?.dates = [OpportunityDates(start: from, end: to)]
    }

    // MARK: - Actions
    @objc private func createActionTapped() {
        print("create")
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

    deinit {
        progressBar.removeFromSuperview()
    }

}
