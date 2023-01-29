//
//  OpportunitiesVC.swift
//  workntour
//
//  Created by Chris Petimezas on 15/6/22.
//

import UIKit
import SharedKit
import CommonUI
import SkeletonView

// TODO: Transition animation to details view -> https://github.com/appssemble/appstore-card-transition

class OpportunitiesVC: BaseVC<OpportunitiesViewModel, OpportunitiesCoordinator> {

    // MARK: - Outlets

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel?.fetchModels()
    }

    override func setupUI() {
        super.setupUI()

        collectionView.register(UINib(nibName: MyOpportunityCell.identifier, bundle: Bundle(for: MyOpportunityCell.self)), forCellWithReuseIdentifier: MyOpportunityCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(mainTitle: "Opportunities", largeTitle: true)
        let plusIcon = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createNewOpportunityAction))
        navigationItem.rightBarButtonItems = [plusIcon]
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationItem.title = ""
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$data
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .store(in: &storage)
    }

    @objc func createNewOpportunityAction() {
        let dataModel = CreateOpportunityViewModel.DataModel(mode: .create)
        coordinator?.navigate(to: .createOpportunity(dataModel: dataModel))
    }

}

// MARK: - CollectionView Delegates
extension OpportunitiesVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, SkeletonCollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOpportunityCell.identifier, for: indexPath) as! MyOpportunityCell

        if let model = viewModel?.data?[safe: indexPath.row] {
            cell.hideSkeleton()
            cell.configure(
                URL(string: model.imageUrls.first ?? ""),
                jobTitle: model.title,
                location: model.location.placemark?.simpleFormat(),
                category: model.category.value,
                dates: model.dates.map { ($0.start, $0.end) })
        } else {
            cell.showAnimatedGradientSkeleton()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.data?.count ?? 2
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MyOpportunityCell.identifier
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 48, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let opportunity = viewModel?.data?[safe: indexPath.row] else {
            return
        }
        let opportunityDto = OpportunityDto(
            memberId: "a1210e1a-5118-4abe-8ee3-6d5927865689",
            category: .farm,
            images: [],
            imagesUrl: ["https://www.hackingwithswift.com/uploads/swift-evolution-7.jpg", "https://images.idgesg.net/images/article/2020/06/swiftui-icon-100850528-large.jpg?auto=webp&quality=85,70", "https://png.pngitem.com/pimgs/s/14-143099_transparent-java-png-ios-swift-logo-png-download.png"],
            title: "Test title",
            description: "Test description",
            typeOfHelp: [.BABYSITTER, .COOKING],
            location: OpportunityLocation(placemark: .init(name: "Καστοριά", country: "Ελλαδα", area: "Δυτικής Μακεδονίας", locality: "Καστοριά", postalCode: "12341"), latitude: 40.5179435, longitude: 21.2502361),
            dates: [.init(start: "2023-04-01", end: "2023-04-30")], minDays: 7, maxDays: 30, workingHours: 32, daysOff: 0,
            languagesRequired: [.BULGARIAN, .ENGLISH, .ITALIAN],
            accommodation: .privateRoom,
            meals: [.breakfast, .lunch],
            learningOpportunities: [.ANIMAL_WELFARE, .CULTURE_EXCHANGE],
            optionals: nil
        )
        let dataModel = CreateOpportunityViewModel.DataModel(mode: .edit(opportunityDto))
        coordinator?.navigate(to: .createOpportunity(dataModel: dataModel))
    }
}
