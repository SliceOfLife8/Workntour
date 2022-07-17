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

    private var userRole: UserRole?
    private var homePageIsVisible: Bool = false

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
        self.userRole = UserDataManager.shared.role
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        var allPages: [TabBarPage]
        switch userRole {
        case .TRAVELER:
            allPages = [.homepage, .profile, .notifications, .settings]
        case .COMPANY_HOST, .INDIVIDUAL_HOST:
            allPages = [.profile, .opportunities, .notifications, .settings]
        case .none: // guest mode
            allPages = [.homepage, .notifications, .settings]
        }

        let pages: [TabBarPage] = allPages.sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })

        let controllers: [UINavigationController] = pages.map({ getTabController($0) })

        rootViewController.setViewControllers(controllers, animated: true)
        // Customize TabBar
        if #available(iOS 15.0, *) {
            updateTabBarAppearance()
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.scriptFont(.medium, size: 10)], for: .normal)
        UITabBar.appearance().barTintColor = UIColor.white
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
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    func removeCoordinator() {
        self.parent.dismissCoordinator(self, animated: true)
        self.parent.rootViewController.showNavigationBar(false)
        self.parent.start()
    }

    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        var navigationViewController: UINavigationController

        switch page {
        case .homepage:
            navigationViewController = homeCoordinator.rootViewController
            homeCoordinator.start()
        case .profile:
            navigationViewController = profileCoordinator.rootViewController
            profileCoordinator.start()
        case .opportunities:
            navigationViewController = opportunitiesCoordinator.rootViewController
            opportunitiesCoordinator.start()
        case .notifications:
            navigationViewController = notificationsCoordinator.rootViewController
            notificationsCoordinator.start()
        case .settings:
            navigationViewController = settingsCoordinator.rootViewController
            settingsCoordinator.start()
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

        /// `ScrollToTop` on homePage only when homeVC is presented and contentOffSet of collectionView is greater than .zero
        if let homePage = (viewController as? UINavigationController)?.visibleViewController as? HomeVC, homePageIsVisible, homePage.collectionView.contentOffset.y > 0 {
            let navigationBarHeight = homePage.navigationController?.navigationBar.bounds.height ?? 0
            let topOffset = CGPoint(x: 0, y: -navigationBarHeight)

            homePage.collectionView.setContentOffset(topOffset, animated: true)
        }

        homePageIsVisible = currentPage() == .homepage
    }
}
