//
//  TabBarCoordinator.swift
//  workntour
//
//  Created by Chris Petimezas on 15/6/22.
//

import UIKit
import SharedKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }

    func selectPage(_ page: TabBarPage)

    func currentPage() -> TabBarPage?
}

final class TabBarCoordinator: NSObject, NavigationCoordinator {

    var parent: MainCoordinator
    var childCoordinators: [Coordinator] = []
    var navigator: NavigatorType
    var rootViewController: TabBarViewController
    var pages: [TabBarPage] = []

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
        switch userRole {
        case .TRAVELER:
            pages = [.homepage, .profile, .notifications, .settings]
        case .COMPANY_HOST, .INDIVIDUAL_HOST:
            pages = [.profile, .opportunities, .notifications, .settings]
        case .none: // guest mode
            pages = [.homepage, .notifications, .settings]
        }

        let controllers: [UINavigationController] = pages.map({ getTabController($0) })

        rootViewController.setViewControllers(controllers, animated: true)
        // Customize TabBar
        updateTabBarAppearance()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.scriptFont(.medium, size: 10)], for: .normal)
        UITabBar.appearance().barTintColor = UIColor.white
        rootViewController.tabBar.clipsToBounds = true // Remove top line
        rootViewController.tabBar.isTranslucent = false
        rootViewController.tabBar.tintColor = UIColor.appColor(.lavender)
        rootViewController.tabBar.unselectedItemTintColor = UIColor.appColor(.lavenderTint1)

        rootViewController.delegate = self
    }

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

        navigationViewController.tabBarItem = UITabBarItem(
            title: page.pageTitleValue,
            image: page.tabIcon?.withRenderingMode(.alwaysOriginal),
            selectedImage: page.tabSelectedIcon
        )

        return navigationViewController
    }

    func currentPage() -> TabBarPage? { TabBarPage(index: rootViewController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        guard let currentIndex = pages.firstIndex(of: page) else { return }
        rootViewController.selectedIndex = currentIndex
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {

        /// `ScrollToTop` on homePage only when homeVC is presented and contentOffSet of collectionView is greater than .zero
        if let homePage = (viewController as? UINavigationController)?.visibleViewController as? HomeVC, homePageIsVisible, homePage.collectionView.contentOffset.y > 0 {
            let navigationBarInitialHeight: CGFloat = 148
            let topSafeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44.0
            let topOffset = CGPoint(x: 0, y: -navigationBarInitialHeight - topSafeAreaInset)

            homePage.collectionView.setContentOffset(topOffset, animated: true)
        }

        homePageIsVisible = currentPage() == .homepage
    }
}
