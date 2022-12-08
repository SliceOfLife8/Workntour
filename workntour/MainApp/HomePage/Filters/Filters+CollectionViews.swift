//
//  Filters+CollectionViews.swift
//  workntour
//
//  Created by Chris Petimezas on 18/7/22.
//

import UIKit
import CommonUI

// MARK: - CollectionView Delegates
extension OpportunitiesFiltersVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func setupCollectionViews() {
        categoriesCollectionView.register(
            UINib(nibName: ChipCell.identifier,
                  bundle: Bundle(for: ChipCell.self)),
            forCellWithReuseIdentifier: ChipCell.identifier
        )
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        typeOfHelpCollectionView.register(
            UINib(nibName: ChipCell.identifier,
                  bundle: Bundle(for: ChipCell.self)),
            forCellWithReuseIdentifier: ChipCell.identifier
        )
        typeOfHelpCollectionView.delegate = self
        typeOfHelpCollectionView.dataSource = self
        typeOfHelpCollectionView.allowsMultipleSelection = true
        accommodationCollectionView.register(
            UINib(nibName: ChipCell.identifier,
                  bundle: Bundle(for: ChipCell.self)),
            forCellWithReuseIdentifier: ChipCell.identifier
        )
        accommodationCollectionView.delegate = self
        accommodationCollectionView.dataSource = self
        mealsCollectionView.register(
            UINib(nibName: ChipCell.identifier,
                  bundle: Bundle(for: ChipCell.self)),
            forCellWithReuseIdentifier: ChipCell.identifier
        )
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.allowsMultipleSelection = true
        languagesCollectionView.register(
            UINib(nibName: ChipCell.identifier,
                  bundle: Bundle(for: ChipCell.self)),
            forCellWithReuseIdentifier: ChipCell.identifier
        )
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChipCell.identifier,
            for: indexPath
        ) as? ChipCell
        else {
            return UICollectionViewCell()
        }

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

        cell.configureLayout(for: .init(title: title ?? ""))

        return cell
    }

    /// Update filterDto datasource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChipCell,
              let title = cell.dataModel?.title
        else {
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChipCell,
              let title = cell.dataModel?.title,
              let viewModel
        else {
            return
        }

        if collectionView == typeOfHelpCollectionView, let typeOfHelp = TypeOfHelp(caseName: title) {
            viewModel.filters.typeOfHelp = viewModel.filters.typeOfHelp.filter { $0 != typeOfHelp }
        } else if collectionView == mealsCollectionView, let meal = Meal(caseName: title) {
            viewModel.filters.meals = viewModel.filters.meals.filter { $0 != meal }
        } else if collectionView == languagesCollectionView, let lang = Language(caseName: title) {
            viewModel.filters.languagesRequired = viewModel.filters.languagesRequired.filter { $0 != lang }
        }
    }
}
