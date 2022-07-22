//
//  OpportunityDetailsVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 4/7/22.
//

import UIKit
import SharedKit
import CommonUI
import MaterialComponents.MaterialChips

class OpportunityDetailsVC: BaseVC<OpportunitesDetailsViewModel, OpportunitiesCoordinator> {
    private(set) var opporunityId: String
    private(set) var userRole: UserRole?

    private var headerInitialHeight: CGFloat = 350
    private var rowItems: [OpportunityDetailsModel] = []

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.tableFooterView = UIView()
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.estimatedRowHeight = 300
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        view.contentInset = .init(top: self.headerInitialHeight, left: 0, bottom: 0, right: 0)
        view.register(UINib(nibName: OpportunityDetailsHeaderView.identifier, bundle: Bundle(for: OpportunityDetailsHeaderView.self)), forHeaderFooterViewReuseIdentifier: OpportunityDetailsHeaderView.identifier)
        view.register(UINib(nibName: OpportunityDetailsMapCell.identifier, bundle: Bundle(for: OpportunityDetailsMapCell.self)), forCellReuseIdentifier: OpportunityDetailsMapCell.identifier)
        view.register(UINib(nibName: OpportunityDetailsCell.identifier, bundle: Bundle(for: OpportunityDetailsCell.self)), forCellReuseIdentifier: OpportunityDetailsCell.identifier)
        view.register(UINib(nibName: OpportunityDetailsDatesCell.identifier, bundle: Bundle(for: OpportunityDetailsDatesCell.self)), forCellReuseIdentifier: OpportunityDetailsDatesCell.identifier)

        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward.square.fill"), for: .normal)
        button.tintColor = UIColor.appColor(.purple)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = UIColor.appColor(.purple)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var bookButton: MDCChipView = {
        let chipView = MDCChipView()
        chipView.titleLabel.text = "Book"
        chipView.titleFont = UIFont.scriptFont(.bold, size: 16)
        chipView.setBackgroundColor(UIColor.appColor(.lavender), for: .normal)
        chipView.setTitleColor(UIColor.appColor(.badgeBg), for: .normal)
        chipView.isHidden = true
        chipView.addTarget(self, action: #selector(bookTapped), for: .touchUpInside)
        return chipView
    }()

    lazy var pageController: ImagePageViewController = {
        let vc = ImagePageViewController()

        return vc
    }()

    // MARK: - Inits
    init(_ id: String) {
        self.opporunityId = id
        self.userRole = UserDataManager.shared.role
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.fetchModels(opportunityId: opporunityId)
    }

    override func setupUI() {
        super.setupUI()

        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
        view.addSubview(bookButton)
        addChild(pageController)
        tableView.addSubview(pageController.view)
        pageController.didMove(toParent: self)

        pageController.view.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(headerInitialHeight)
        }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }

        bookButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.snp.bottom).offset(-16)
            $0.width.equalTo(64)
            $0.height.equalTo(64)
        }
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$images
            .sink(receiveValue: { [weak self] images in
                self?.pageController.reloadData(withImages: images)
            })
            .store(in: &storage)

        viewModel?.$data
            .filter { $0.count > 0 }
            .sink(receiveValue: { [weak self] data in
                self?.rowItems = data
                let isHost = self?.userRole?.oneOf(other: .COMPANY_HOST, .INDIVIDUAL_HOST) == true
                self?.deleteButton.isHidden = isHost ? false : true
                self?.bookButton.isHidden = (self?.userRole == .TRAVELER) ? false : true
                self?.tableView.reloadData()
            })
            .store(in: &storage)

        viewModel?.$opportunityWasDeleted
            .sink(receiveValue: { [weak self] status in
                if status {
                    self?.coordinator?.navigate(to: .updateOpportunitiesOnLanding)
                }
            })
            .store(in: &storage)

        viewModel?.$errorMessage
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] _ in
                let showAlertAction = DefaultStep.showAlert(title: "Something went wrong", subtitle: "Please try again.")
                self?.coordinator?.navigate(to: .state(showAlertAction))
                if let homeCoordinator = self?.otherCoordinator as? HomeCoordinator {
                    homeCoordinator.navigate(to: .state(showAlertAction))
                }
            })
            .store(in: &storage)
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.coordinator?.navigate(to: .state(.back))

        if let homeCoordinator = otherCoordinator as? HomeCoordinator {
            homeCoordinator.navigate(to: .state(.back))
        }
    }

    @objc private func deleteButtonTapped() {
        self.coordinator?.navigate(to: .deleteOpportunity)
    }

    @objc private func bookTapped() {
        guard let startDate = viewModel?.opportunityDates?.start?.asDate(),
              let endDate = viewModel?.opportunityDates?.end?.asDate() else {
            return
        }

        let dates = FindAvailableDatesVC(startDate: startDate, endDate: endDate)
        self.navigationController?.pushViewController(dates, animated: true)
    }

    func deleteOpportunity() {
        self.viewModel?.deleteOpportunity(opportunityId: opporunityId)
    }

}

extension OpportunityDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OpportunityDetailsHeaderView.identifier)  as? OpportunityDetailsHeaderView

        view?.configure(title: viewModel?.headerModel?.title,
                        location: viewModel?.headerModel?.area,
                        category: viewModel?.headerModel?.category.value)
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowItems.count
    }
    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = rowItems[safe: indexPath.row] else {
            assertionFailure()
            return UITableViewCell()
        }

        if let location = model.location {
            let mapCell = tableView.dequeueReusableCell(withIdentifier: OpportunityDetailsMapCell.identifier, for: indexPath) as! OpportunityDetailsMapCell
            mapCell.setupArea(latitude: location.latitude,
                              longitude: location.longitude)

            return mapCell
        } else if model.showDays || model.showDates {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: OpportunityDetailsDatesCell.identifier) as! OpportunityDetailsDatesCell
            dateCell.setup(leftHeader: model.showDays ? "Stay at least" : "Starts",
                           rightHeader: model.showDays ? "Stay up to" : "Ends",
                           title: model.title,
                           value: model.description,
                           showDays: model.showDays)

            return dateCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OpportunityDetailsCell.identifier, for: indexPath) as! OpportunityDetailsCell
            cell.setup(title: model.title,
                       value: model.description)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 { // Map-View
            return 250
        } else {
            return UITableView.automaticDimension
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let offset = -scrollView.contentOffset.y

            self.pageController.view.snp.updateConstraints {
                $0.height.equalTo(offset)
            }
            // Update tableview top padding distance when images are out of screen.
            self.tableView.snp.updateConstraints {
                let topPadding = (offset < 0) ? view.safeAreaInsets.top : .zero
                $0.top.equalTo(topPadding)
            }
        }
    }
}
