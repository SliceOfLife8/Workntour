//
//  OpportunitiesFiltersVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 13/7/22.
//

import UIKit
import CommonUI
import SharedKit
import MaterialComponents.MaterialChips

class OpportunitiesFiltersVC: BaseVC<OpportunitiesFiltersViewModel, HomeCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var daysSlider: RangeSeekSlider!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var typeOfHelpCollectionView: UICollectionView!
    @IBOutlet weak var mealsCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var accommodationCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var languagesCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var showResults: PrimaryButton!
    @IBOutlet weak var clearAllButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }

    private func setupNavBar() {
        setupNavigationBar(mainTitle: "Filters")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTapped))
    }

    override func setupUI() {
        super.setupUI()

        daysSlider.minLabelFont = UIFont.scriptFont(.semibold, size: 14)
        daysSlider.maxLabelFont = UIFont.scriptFont(.semibold, size: 14)
        daysSlider.delegate = self
        clearAllButton.underline()
        setupCollectionViews()
    }

    private func setupCollectionViews() {
        categoriesCollectionView.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        typeOfHelpCollectionView.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        typeOfHelpCollectionView.delegate = self
        typeOfHelpCollectionView.dataSource = self
        typeOfHelpCollectionView.allowsMultipleSelection = true
        accommodationCollectionView.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        accommodationCollectionView.delegate = self
        accommodationCollectionView.dataSource = self
        mealsCollectionView.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.allowsMultipleSelection = true
        languagesCollectionView.register(
            MDCChipCollectionViewCell.self,
            forCellWithReuseIdentifier: "identifier")
        languagesCollectionView.delegate = self
        languagesCollectionView.dataSource = self
        languagesCollectionView.allowsMultipleSelection = true
    }

    // MARK: - Actions
    @objc private func closeBtnTapped() {
        self.dismiss(animated: true)
    }

    @IBAction func selectDatesBtnTapped(_ sender: Any) {
        print("select dates")
    }

    @IBAction func clearAllBtnTapped(_ sender: Any) {
        print("clear all")
    }

    @IBAction func showResultsBtnTapped(_ sender: Any) {
        print("show results!")
    }
}

extension OpportunitiesFiltersVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return OpportunityCategory.allCases.count
        } else if collectionView == typeOfHelpCollectionView {
            return TypeOfHelp.allCases.count
        } else if collectionView == accommodationCollectionView {
            return Accommodation.allCases.count
        } else if collectionView == mealsCollectionView {
            return Meal.allCases.count
        } else if collectionView == languagesCollectionView {
            return Language.allCases.count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell

        let chipView = cell.chipView
        var title: String?

        if collectionView == categoriesCollectionView {
            title = OpportunityCategory.allCases[safe: indexPath.row]?.value
        } else if collectionView == typeOfHelpCollectionView {
            title = TypeOfHelp.allCases[safe: indexPath.row]?.value
        } else if collectionView == accommodationCollectionView {
            title = Accommodation.allCases[safe: indexPath.row]?.value
        } else if collectionView == mealsCollectionView {
            title = Meal.allCases[safe: indexPath.row]?.value
        } else if collectionView == languagesCollectionView {
            title = Language.allCases[safe: indexPath.row]?.value
        }

        chipView.titleLabel.text = title
        chipView.titleFont = UIFont.scriptFont(.bold, size: 12)
        chipView.setBackgroundColor(UIColor.appColor(.badgeBg), for: .normal)
        chipView.setBackgroundColor(UIColor.appColor(.lavender), for: .selected)
        chipView.setTitleColor(UIColor.appColor(.lavender2), for: .normal)
        chipView.setTitleColor(.white, for: .selected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // For action chips, we never want the chip to stay in selected state.
        // Other possible apporaches would be relying on theming or Customizing collectionViewCell
        // selected state.
        // collectionView.deselectItem(at: indexPath, animated: false)
        // Trigger the action
    }
}

extension OpportunitiesFiltersVC: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
        print("minDays: \(minValue)")
        return nil
    }

    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue: CGFloat) -> String? {
        print("maxDays: \(stringForMaxValue)")
        return nil
    }
}
