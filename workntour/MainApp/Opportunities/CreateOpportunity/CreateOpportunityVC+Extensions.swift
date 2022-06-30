//
//  CreateOpportunityVC+Extensions.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 28/6/22.
//

import UIKit
import CommonUI

// MARK: - UITextField & UITextView Delegates
extension CreateOpportunityVC: GradientTFDelegate, UITextViewDelegate {
    func shouldReturn(_ textField: UITextField) {
        print("should return")
    }

    func notEditableTextFieldTriggered(_ textField: UITextField) {
        if textField == categoryTextField {
            categoriesDropDown.anchorView = categoryTextField
            categoriesDropDown.show()
        } else if textField == typeOfHelpTextField {
            typeOfHelpDropDown.anchorView = typeOfHelpTextField
            typeOfHelpDropDown.show()
        } else if textField == languagesRequiredTextField {
            languagesRequiredDropDown.anchorView = languagesRequiredTextField
            languagesRequiredDropDown.show()
        } else if textField == languagesSpokenTextField {
            languagesSpokenDropDown.anchorView = languagesSpokenTextField
            languagesSpokenDropDown.show()
        } else if textField == accommodationsTextField {
            accommodationsDropDown.anchorView = accommodationsTextField
            accommodationsDropDown.show()
        } else if textField == learningOpportunitesTextField {
            learningOpportunitiesDropDown.anchorView = learningOpportunitesTextField
            learningOpportunitiesDropDown.show()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == jobTitleTextView {
            self.viewModel?.jobTitle = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if textView == jobDescriptionTextView {
            self.viewModel?.jobDescription = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

// MARK: - Images CollectionView
extension CreateOpportunityVC: UICollectionViewDataSource, OpportunityImageCellDelegate {
    func setupCollectionView() {
        imagesCollectionView.register(UINib(nibName: OpportunityImageCell.identifier, bundle: Bundle(for: OpportunityImageCell.self)), forCellWithReuseIdentifier: OpportunityImageCell.identifier)
        let gesture = UILongPressGestureRecognizer(target: self,
                                                   action: #selector(handleLongPressGesture(_:)))
        imagesCollectionView.addGestureRecognizer(gesture)
        imagesCollectionView.dataSource = self
    }

    func removeImage(_ cell: OpportunityImageCell) {
        guard let selectedRow = imagesCollectionView.indexPath(for: cell)?.row else {
            return
        }

        self.viewModel?.images.remove(at: selectedRow)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.images.count ?? 0
    }

    // swiftlint:disable force_cast
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OpportunityImageCell.identifier, for: indexPath) as! OpportunityImageCell

        cell.imageView.image = viewModel?.images[indexPath.row]
        cell.delegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let item = viewModel?.images.remove(at: sourceIndexPath.row) else { return }
        viewModel?.images.insert(item, at: destinationIndexPath.row)
    }

    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = imagesCollectionView.indexPathForItem(at: gesture.location(in: imagesCollectionView)) else {
                return
            }

            imagesCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            imagesCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: imagesCollectionView))
        case .ended:
            imagesCollectionView.endInteractiveMovement()
        default:
            imagesCollectionView.cancelInteractiveMovement()
        }
    }
}

extension CreateOpportunityVC: CheckBoxDelegate {
    /// Update meals object
    func didChange(isChecked: Bool, box: Checkbox) {
        guard let _viewModel = viewModel else { return }

        if box == breakfastBtn {
            if isChecked {
                _viewModel.meals.append(.breakfast)
            } else {
                _viewModel.meals = _viewModel.meals.filter { $0 != .breakfast }
            }
        } else if box == lunchBtn {
            if isChecked {
                _viewModel.meals.append(.lunch)
            } else {
                _viewModel.meals = _viewModel.meals.filter { $0 != .lunch }
            }
        } else if box == dinnerBtn {
            if isChecked {
                _viewModel.meals.append(.dinner)
            } else {
                _viewModel.meals = _viewModel.meals.filter { $0 != .dinner }
            }
        } else if box == useSharedKitchenBtn {
            if isChecked {
                _viewModel.meals.append(.useSharedKitchen)
            } else {
                _viewModel.meals = _viewModel.meals.filter { $0 != .useSharedKitchen }
            }
        }
    }
}
