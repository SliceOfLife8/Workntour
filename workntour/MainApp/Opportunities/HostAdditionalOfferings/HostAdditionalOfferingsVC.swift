//
//  HostAdditionalOfferingsVC.swift
//  workntour
//
//  Created by Chris Petimezas on 27/1/23.
//

import UIKit
import CommonUI
import SharedKit
import EasyTipView

class HostAdditionalOfferingsVC: BaseVC<HostAdditionalOfferingsViewModel, OpportunitiesCoordinator> {

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

    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var languagesCollectionView: DynamicHeightCollectionView! {
        didSet {
            languagesCollectionView.register(
                UINib(nibName: ChipCell.identifier,
                      bundle: Bundle(for: ChipCell.self)),
                forCellWithReuseIdentifier: ChipCell.identifier
            )
            languagesCollectionView.delegate = self
            languagesCollectionView.dataSource = self
            languagesCollectionView.allowsMultipleSelection = true
        }
    }
    @IBOutlet weak var offeringsLabel: UILabel!
    @IBOutlet weak var offeringsCollectionView: DynamicHeightCollectionView! {
        didSet {
            offeringsCollectionView.register(
                UINib(nibName: ChipCell.identifier,
                      bundle: Bundle(for: ChipCell.self)),
                forCellWithReuseIdentifier: ChipCell.identifier
            )
            offeringsCollectionView.delegate = self
            offeringsCollectionView.dataSource = self
            offeringsCollectionView.allowsMultipleSelection = true
        }
    }
    @IBOutlet weak var experiencesLabel: UILabel!
    @IBOutlet weak var experienceTextView: UITextView! {
        didSet {
            experienceTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            experienceTextView.layer.borderColor = UIColor.appColor(.purple).cgColor
            experienceTextView.layer.borderWidth = 1
            experienceTextView.layer.cornerRadius = 8
            experienceTextView.delegate = self
        }
    }
    @IBOutlet weak var dietaryLabel: UILabel!
    @IBOutlet weak var dietarySegmentedControl: UISegmentedControl!
    @IBOutlet weak var couplesAcceptedLabel: UILabel!
    @IBOutlet weak var couplesAcceptedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var freeWifiLabel: UILabel!
    @IBOutlet weak var freeWifiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var smokingAllowedLabel: UILabel!
    @IBOutlet weak var smokingAllowedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var petsAllowedLabel: UILabel!
    @IBOutlet weak var petsAllowedSegmentedControl: UISegmentedControl!

    // MARK: - LifeCycle

    override func setupUI() {
        super.setupUI()

        setupNavigationBar(mainTitle: "extra_offerings".localized())
        let addIcon = UIBarButtonItem(
            title: "navigation_item_add".localized(),
            style: .plain,
            target: self,
            action: #selector(addIconTapped)
        )
        navigationItem.rightBarButtonItems = [addIcon]

        languagesLabel.text = "languages_spoken".localized()
        offeringsLabel.text = "extra_offerings".localized()
        experiencesLabel.text = "experiences_offered".localized()
        experienceTextView.placeholder = "experiences_offered_description".localized()
        dietaryLabel.text = "special_dietary".localized()
        couplesAcceptedLabel.text = "couples_accepted".localized()
        freeWifiLabel.text = "free_wifi".localized()
        smokingAllowedLabel.text = "smoking_allowed".localized()
        petsAllowedLabel.text = "pets_allowed".localized()
        preselectChips()
        experienceTextView.text = viewModel?.dataModel.experiences
        preselectSegmentedControls()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        easyTipView?.dismiss()
        easyTipView = nil
    }

    // MARK: - Private Methods

    private func preselectChips() {
        viewModel?.dataModel.languagesSpoken.compactMap { $0.index }.forEach { row in
            languagesCollectionView.selectItem(
                at: IndexPath(row: row, section: 0),
                animated: false,
                scrollPosition: .centeredHorizontally
            )
        }

        viewModel?.dataModel.additionalOfferings.compactMap { $0.index }.forEach { row in
            offeringsCollectionView.selectItem(
                at: IndexPath(row: row, section: 0),
                animated: false,
                scrollPosition: .centeredHorizontally
            )
        }
    }

    private func preselectSegmentedControls() {
        guard let dataModel = viewModel?.dataModel else { return }

        dietarySegmentedControl.selectedSegmentIndex = (dataModel.dietary == .NONE)
        ? 0
        : (dataModel.dietary == .VEGAN ? 1 : 2)
        if let couplesOption = dataModel.coupleAccepted {
            couplesAcceptedSegmentedControl.selectedSegmentIndex = couplesOption ? 0 : 1
        }
        if let wifiOption = dataModel.wifi {
            freeWifiSegmentedControl.selectedSegmentIndex = wifiOption ? 0 : 1
        }
        if let smokingOption = dataModel.smoking {
            smokingAllowedSegmentedControl.selectedSegmentIndex = smokingOption ? 0 : 1
        }
        if let petsOption = dataModel.pets {
            petsAllowedSegmentedControl.selectedSegmentIndex = petsOption ? 0 : 1
        }
    }

    // MARK: - Actions

    @objc func addIconTapped() {
        guard let dataModel = viewModel?.dataModel else { return }
        coordinator?.addOpportunityExtraOfferings(optionals: dataModel.convertToOpportunityOptionals())
    }

    @IBAction func offeringsInfoButtonTapped(_ sender: UIButton) {
        easyTipView?.dismiss()
        easyTipView = EasyTipView(
            text: "extra_offerings_info".localized(),
            preferences: preferences
        )
        easyTipView?.show(forView: sender, withinSuperview: view)
    }

    @IBAction func dietaryHasChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            viewModel?.dataModel.dietary = .NONE
        case 1:
            viewModel?.dataModel.dietary = .VEGAN
        default:
            viewModel?.dataModel.dietary = .VEGETARIAN
        }
    }

    @IBAction func couplesAcceptedHasChanged(_ sender: Any) {
        viewModel?.dataModel.coupleAccepted = couplesAcceptedSegmentedControl.selectedSegmentIndex == 0 ? true : false
    }

    @IBAction func wifiHasChanged(_ sender: Any) {
        viewModel?.dataModel.wifi = freeWifiSegmentedControl.selectedSegmentIndex == 0 ? true : false
    }

    @IBAction func smokingHasChanged(_ sender: Any) {
        viewModel?.dataModel.smoking = smokingAllowedSegmentedControl.selectedSegmentIndex == 0 ? true : false
    }

    @IBAction func petsHasChanged(_ sender: Any) {
        viewModel?.dataModel.pets = petsAllowedSegmentedControl.selectedSegmentIndex == 0 ? true : false
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HostAdditionalOfferingsVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == languagesCollectionView {
            return viewModel?.dataModel.languagesDataSource.count ?? 0
        }
        else {
            return viewModel?.dataModel.offeringsDataSource.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChipCell.identifier,
            for: indexPath
        ) as? ChipCell
        else {
            return UICollectionViewCell()
        }

        if let value = collectionView == languagesCollectionView
            ? viewModel?.dataModel.languagesDataSource[safe: indexPath.row]?.value
            : viewModel?.dataModel.offeringsDataSource[safe: indexPath.row]?.value {
            cell.configureLayout(for: .init(title: value))
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChipCell,
              let title = cell.dataModel?.title
        else {
            return
        }

        if collectionView == languagesCollectionView, let language = Language(caseName: title) {
            viewModel?.dataModel.languagesSpoken.append(language)
        }
        else if collectionView == offeringsCollectionView, let offering = AdditionalOfferings(caseName: title) {
            viewModel?.dataModel.additionalOfferings.append(offering)
        }
        else {
            assertionFailure("Check enums above!")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChipCell,
              let title = cell.dataModel?.title,
              let dataModel = viewModel?.dataModel
        else {
            return
        }

        if collectionView == languagesCollectionView, let language = Language(caseName: title) {
            dataModel.languagesSpoken = dataModel.languagesSpoken.filter { $0 != language }
        }
        else if collectionView == offeringsCollectionView, let offering = AdditionalOfferings(caseName: title) {
            dataModel.additionalOfferings = dataModel.additionalOfferings.filter { $0 != offering }
        }
    }
}

// MARK: - UITextViewDelegate
extension HostAdditionalOfferingsVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        guard let viewModel else { return }
        viewModel.dataModel.experiences = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - UITextViewDelegate
extension HostAdditionalOfferingsVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        easyTipView?.dismiss()
    }
}
