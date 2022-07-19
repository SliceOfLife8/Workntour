//
//  OpportunitiesFiltersVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 13/7/22.
//

import UIKit
import CommonUI
import SharedKit

class OpportunitiesFiltersVC: BaseVC<OpportunitiesFiltersViewModel, HomeCoordinator> {

    // MARK: - Outlets
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var daysSlider: RangeSeekSlider!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var typeOfHelpCollectionView: UICollectionView!
    @IBOutlet weak var mealsCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var accommodationCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var languagesCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var showResults: PrimaryButton!
    @IBOutlet weak var clearAllButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        daysSlider.delegate = self
    }

    private func setupNavBar() {
        setupNavigationBar(mainTitle: "Filters")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeBtnTapped))
    }

    override func setupUI() {
        super.setupUI()

        daysSlider.minLabelFont = UIFont.scriptFont(.semibold, size: 14)
        daysSlider.maxLabelFont = UIFont.scriptFont(.semibold, size: 14)
        clearAllButton.underline()
        setupCollectionViews()
        selectChips()
        setupSlider()

        if let dateStart = viewModel?.filters.startDate, let dateEnd = viewModel?.filters.endDate {
            datesLabel.text = "\(dateStart) - \(dateEnd)"
        }
    }

    private func selectChips() {
        // Categories
        if let categoryIndex = viewModel?.filters.category?.index {
            categoriesCollectionView.selectItem(at: IndexPath(row: categoryIndex, section: 0),
                                                animated: false,
                                                scrollPosition: .centeredHorizontally)
        }
        // Type Of help
        viewModel?.filters.typeOfHelp.compactMap({ $0.index }).forEach { row in
            typeOfHelpCollectionView.selectItem(at: IndexPath(row: row, section: 0),
                                                animated: false,
                                                scrollPosition: .centeredHorizontally)
        }
        // Accommodation
        if let accommodationIndex = viewModel?.filters.accommodation?.index {
            accommodationCollectionView.selectItem(at: IndexPath(row: accommodationIndex, section: 0),
                                                   animated: false,
                                                   scrollPosition: .centeredHorizontally)
        }
        // Meals
        viewModel?.filters.meals.compactMap({ $0.index }).forEach { row in
            mealsCollectionView.selectItem(at: IndexPath(row: row, section: 0),
                                           animated: false,
                                           scrollPosition: .centeredHorizontally)
        }
        // Required languages
        viewModel?.filters.languagesRequired.compactMap({ $0.index }).forEach { row in
            languagesCollectionView.selectItem(at: IndexPath(row: row, section: 0),
                                               animated: false,
                                               scrollPosition: .centeredHorizontally)
        }
    }

    private func setupSlider() {
        let minValue = viewModel?.filters.minDays ?? 1
        let maxValue = viewModel?.filters.maxDays ?? 100
        daysSlider.selectedMinValue = CGFloat(minValue)
        daysSlider.selectedMaxValue = CGFloat(maxValue)
        daysSlider.refresh()
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$totalOpportunities
            .map { $0 > 0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: showResults)
            .store(in: &storage)

        viewModel?.$totalOpportunities
            .sink(receiveValue: { [weak self] number in
                let text = (number > 0) ? "Show \(number) opportunities" : "There are no opportunities"
                self?.showResults.setTitle(text, for: .normal)
            })
            .store(in: &storage)
    }

    func updateDateLabel(start: String, end: String) {
        datesLabel.text = "\(start) - \(end)"
        viewModel?.filters.addDates(start: start, end: end)
    }

    // MARK: - Actions
    @objc private func closeBtnTapped() {
        self.dismiss(animated: true)
    }

    @IBAction func selectDatesBtnTapped(_ sender: Any) {
        self.coordinator?.navigate(to: .showDatePicker)
    }

    /// Reset UI + Datasources + Update HomePage filters state
    @IBAction func clearAllBtnTapped(_ sender: Any) {
        // If filters are already empty, then return immediately
        guard viewModel?.filters.basicFiltersAreEmpty == false else {
            return
        }

        datesLabel.text?.removeAll()
        categoriesCollectionView.indexPathsForSelectedItems?
            .forEach { categoriesCollectionView.deselectItem(at: $0, animated: false) }
        typeOfHelpCollectionView.indexPathsForSelectedItems?
            .forEach { typeOfHelpCollectionView.deselectItem(at: $0, animated: false) }
        accommodationCollectionView.indexPathsForSelectedItems?
            .forEach { accommodationCollectionView.deselectItem(at: $0, animated: false) }
        mealsCollectionView.indexPathsForSelectedItems?
            .forEach { mealsCollectionView.deselectItem(at: $0, animated: false) }
        languagesCollectionView.indexPathsForSelectedItems?
            .forEach { languagesCollectionView.deselectItem(at: $0, animated: false) }

        viewModel?.filters.resetFilters()
        setupSlider()
        // Update homeVC in order to reset filters
        guard let _viewModel = viewModel else {
            return
        }

        self.coordinator?.navigate(to: .updateFilters(_viewModel.filters))
    }

    @IBAction func showResultsBtnTapped(_ sender: Any) {
        guard let _viewModel = viewModel else {
            return
        }

        self.dismiss(animated: true, completion: {
            self.coordinator?.navigate(to: .updateFilters(_viewModel.filters))
        })
    }
}

extension OpportunitiesFiltersVC: RangeSeekSliderDelegate {
    func didEndTouches(in slider: RangeSeekSlider) {
        self.viewModel?.filters.addDays(min: Int(slider.selectedMinValue),
                                        max: Int(slider.selectedMaxValue))
    }
}
