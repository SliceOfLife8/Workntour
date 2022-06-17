//
//  TabBarCoordinator.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 15/6/22.
//

import UIKit
import SharedKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }

    func selectPage(_ page: TabBarPage)

    func setSelectedIndex(_ index: Int)

    func currentPage() -> TabBarPage?
}

final class TabBarCoordinator: NSObject, NavigationCoordinator {

    var parent: MainCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: TabBarViewController

    /// `Main Coordinators of our application`
    lazy var homeCoordinator: HomeCoordinator = {
        return HomeCoordinator(self)
    }()

    lazy var profileCoordinator: ProfileCoordinator = {
        return ProfileCoordinator(self)
    }()

    lazy var opportunitiesCoordinator: OpportunitiesCoordinator = {
        return OpportunitiesCoordinator(self)
    }()

    lazy var notificationsCoordinator: NotificationsCoordinator = {
        return NotificationsCoordinator(self)
    }()

    lazy var settingsCoordinator: SettingsCoordinator = {
        return SettingsCoordinator(self)
    }()

    init(parent: MainCoordinator, _ navigationController: UINavigationController) {
        self.parent = parent

        self.navigator = Navigator(navigationController: navigationController)
        self.rootViewController = .init()
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = TabBarPage.allCases.sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })

        let controllers: [UINavigationController] = pages.map({ getTabController($0) })

        rootViewController.setViewControllers(controllers, animated: true)
        // Customize TabBar
        if #available(iOS 15.0, *) {
            updateTabBarAppearance()
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.scriptFont(.medium, size: 10)], for: .normal)
        rootViewController.tabBar.clipsToBounds = true // Remove top line
        rootViewController.tabBar.isTranslucent = false
        rootViewController.tabBar.tintColor = UIColor.appColor(.lavender)
        rootViewController.tabBar.unselectedItemTintColor = UIColor.appColor(.lavenderTint1)

        rootViewController.delegate = self
    }

    @available(iOS 15.0, *)
    private func updateTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    func removeCoordinator() {
        self.parent.dismissCoordinator(self, animated: true)
        self.parent.rootViewController.setNavigationBarHidden(false, animated: false)
        self.parent.start()
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        var navigationViewController: UINavigationController

        switch page {
        case .homepage:
            navigationViewController = homeCoordinator.rootViewController
        case .profile:
            navigationViewController = profileCoordinator.rootViewController
        case .opportunities:
            navigationViewController = opportunitiesCoordinator.rootViewController
        case .notifications:
            navigationViewController = notificationsCoordinator.rootViewController
        case .settings:
            navigationViewController = settingsCoordinator.rootViewController
        }

        navigationViewController.tabBarItem = UITabBarItem(title: page.pageTitleValue, image: page.tabIcon?.withRenderingMode(.alwaysOriginal), selectedImage: page.tabSelectedIcon)

        return navigationViewController
    }

    func currentPage() -> TabBarPage? { TabBarPage(index: rootViewController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        rootViewController.selectedIndex = page.pageOrderNumber()
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }

        rootViewController.selectedIndex = page.pageOrderNumber()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
    }
}
