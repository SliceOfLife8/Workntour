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
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == jobTitleTextView {
            self.viewModel?.jobTitle = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
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
