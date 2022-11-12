//
//  ProfileSelectAttributesVC.swift
//  workntour
//
//  Created by Chris Petimezas on 12/11/22.
//

import UIKit
import CommonUI

class ProfileSelectAttributesVC: BaseVC<ProfileSelectAttributesViewModel, ProfileCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: DynamicHeightCollectionView! {
        didSet {
            collectionView.register(
                UINib(nibName: ChipCell.identifier,
                      bundle: Bundle(for: ChipCell.self)),
                forCellWithReuseIdentifier: ChipCell.identifier
            )
            collectionView.register(
                UINib(nibName: SelectAttributesHeaderView.identifier,
                      bundle: Bundle(for: SelectAttributesHeaderView.self)),
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SelectAttributesHeaderView.identifier
            )
            collectionView.allowsMultipleSelection = true
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let viewModel else { return }

        setupNavigationBar(mainTitle: viewModel.data.navigationBarTitle)
        let saveAction = UIBarButtonItem(
            title: "save".localized(),
            style: .plain,
            target: self,
            action: #selector(saveBtnTapped)
        )
        navigationItem.rightBarButtonItems = [saveAction]
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.data.attributes.filter { $0.isSelected }.count >= 3
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$profileUpdated
            .dropFirst()
            .sink(receiveValue: { [weak self] status in
                print("status: \(status)")
            })
            .store(in: &storage)
    }

    // MARK: - Private Methods

    func updateHeaderView() {
        guard let data = viewModel?.data else { return }
        let headerView = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionHeader,
            at: .init(row: 0, section: 0)
        ) as? SelectAttributesHeaderView
        let currentItemsNum = data.attributes.filter { $0.isSelected }.count
        headerView?.configureLayout(for: .init(
            title: data.headerTitle,
            description: data.description,
            minQuantity: data.minItemsToBeSelected,
            currentQuantity: currentItemsNum
        ))
        navigationItem.rightBarButtonItem?.isEnabled = currentItemsNum >= 3
    }

    // MARK: - Actions

    @objc private func saveBtnTapped() {
        viewModel?.updateTravelerProfile()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ProfileSelectAttributesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.data.attributes.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChipCell.identifier,
            for: indexPath
        ) as? ChipCell,
              let attribute = viewModel?.data.attributes[safe: indexPath.row]
        else {
            assertionFailure("Check viewModel attributes!")
            return UICollectionViewCell()
        }

        cell.configureLayout(for: .init(title: attribute.title))
        if attribute.isSelected {
            collectionView.selectItem(
                at: indexPath,
                animated: true,
                scrollPosition: .centeredVertically
            )
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SelectAttributesHeaderView.identifier,
                for: indexPath
            ) as? SelectAttributesHeaderView,
                  let data = viewModel?.data
            else {
                return UICollectionReusableView()
            }

            headerView.configureLayout(for: .init(
                title: data.headerTitle,
                description: data.description,
                minQuantity: data.minItemsToBeSelected,
                currentQuantity: data.attributes.filter { $0.isSelected }.count
            ))
            
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update datasource + headerView
        viewModel?.data.attributes[safe: indexPath.row]?.updateAttribute(true)
        updateHeaderView()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel?.data.attributes[safe: indexPath.row]?.updateAttribute(false)
        updateHeaderView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 24, left: 24, bottom: 24, right: 24)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 115)
    }
}
