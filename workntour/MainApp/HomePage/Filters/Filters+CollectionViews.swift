//
//  Filters+CollectionViews.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 18/7/22.
//

import UIKit
import MaterialComponents.MaterialChips

// MARK: - CollectionView Delegates
extension OpportunitiesFiltersVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func setupCollectionViews() {
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

    /// Update filterDto datasource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chipCell = collectionView.cellForItem(at: indexPath) as? MDCChipCollectionViewCell
        guard let title = chipCell?.chipView.titleLabel.text else {
            return
        }

        if collectionView == categoriesCollectionView {
            viewModel?.filters.category = OpportunityCategory(caseName: title)
        } else if collectionView == typeOfHelpCollectionView, let typeOfHelp = TypeOfHelp(caseName: title) {
            viewModel?.filters.typeOfHelp.append(typeOfHelp)
        } else if collectionView == accommodationCollectionView {
            viewModel?.filters.accommodation = Accommodation(caseName: title)
        } else if collectionView == mealsCollectionView, let meal = Meal(caseName: title) {
            viewModel?.filters.meals.append(meal)
        } else if collectionView == languagesCollectionView, let lang = Language(caseName: title) {
            viewModel?.filters.languagesRequired.append(lang)
        }
    }

    /// Update filter datasource. Remove options only from collectionViews that have multiple selection enabled.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let chipCell = collectionView.cellForItem(at: indexPath) as? MDCChipCollectionViewCell
        guard let title = chipCell?.chipView.titleLabel.text, let _viewModel = viewModel else {
            return
        }

        if collectionView == typeOfHelpCollectionView, let typeOfHelp = TypeOfHelp(caseName: title) {
            _viewModel.filters.typeOfHelp = _viewModel.filters.typeOfHelp.filter { $0 != typeOfHelp }
        } else if collectionView == mealsCollectionView, let meal = Meal(caseName: title) {
            _viewModel.filters.meals = _viewModel.filters.meals.filter { $0 != meal }
        } else if collectionView == languagesCollectionView, let lang = Language(caseName: title) {
            _viewModel.filters.languagesRequired = _viewModel.filters.languagesRequired.filter { $0 != lang }
        }
    }
}
