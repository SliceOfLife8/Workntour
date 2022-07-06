//
//  OpportunityDetailsVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 4/7/22.
//

import UIKit
import SharedKit
import CommonUI

class OpportunityDetailsVC: BaseVC<OpportunitesDetailsViewModel, OpportunitiesCoordinator> {
    open var headerInitialHeight: CGFloat = 300

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

        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
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
        return button
    }()

    lazy var pageController: ImagePageViewController = {
        let vc = ImagePageViewController()

        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.setContentOffset(CGPoint(x: 0, y: -headerInitialHeight), animated: true)
    }

    override func setupUI() {
        super.setupUI()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(deleteButton)
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
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$images
            .sink(receiveValue: { [weak self] images in
                self?.pageController.reloadData(withImages: images)
            })
            .store(in: &storage)
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.coordinator?.navigate(to: .back)
    }

    @objc private func deleteButtonTapped() {
        self.coordinator?.navigate(to: .deleteOpportunity)
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
        return viewModel?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.data[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: OpportunityDetailsCell.identifier, for: indexPath) as? OpportunityDetailsCell,
              let mapCell = tableView.dequeueReusableCell(withIdentifier: OpportunityDetailsMapCell.identifier) as? OpportunityDetailsMapCell
        else {
            assertionFailure()
            return UITableViewCell()
        }

        if let location = model.location {
            mapCell.setupArea(latitude: location.latitude,
                              longitude: location.longitude)

            return mapCell
        } else {
            cell.setup(title: model.title,
                       value: model.description,
                       showDays: model.showDates)

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
        }
    }
}
