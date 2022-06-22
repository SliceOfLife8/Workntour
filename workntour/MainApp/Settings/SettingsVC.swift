//
//  SettingsVC.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 17/6/22.
//

import UIKit
import SharedKit
import CommonUI
import CombineDataSources

class SettingsVC: BaseVC<SettingsViewModel, SettingsCoordinator> {

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        // tableView.backgroundColor = UIColor.appColor(.primary)
        tableView.backgroundColor = UIColor.appColor(.lightGray)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.fetchOptions()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func setupUI() {
        super.setupUI()

        setupNavigationBar(withLargeTitle: tabBarController?.tabBar.selectedItem?.title)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func bindViews() {
        super.bindViews()

        viewModel?.$logoutAction
            .sink { [weak self] status in
                if status {
                    self?.coordinator?.navigate(to: .logout)
                }
            }
            .store(in: &storage)
    }

}

// MARK: - UITableView Delegates
extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data[section].options.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = viewModel?.data[section]
        return section?.title
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textAlignment = .center
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = viewModel?.data[section]
        return section?.bottomTitle
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel?.data[indexPath.section].options[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell
        else {
            assertionFailure()
            return UITableViewCell()
        }

        cell.configure(title: model.title,
                       icon: model.icon,
                       iconBgColor: model.iconBackgroundColor,
                       type: model.accessoryType)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel?.data[indexPath.section].options[indexPath.row]
        model?.handle()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }

    // swiftlint:disable multiple_closures_with_trailing_closure
    func deselectRowWithTransition(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { _ in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }) { context in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
        }
    }
}
