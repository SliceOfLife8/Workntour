//
//  SceneDelegate.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import UIKit
import SharedKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        if let urlContext = connectionOptions.urlContexts.first {

            let sendingAppID = urlContext.options.sourceApplication
            let url = urlContext.url
            print("source application = \(sendingAppID ?? "Unknown")")
            print("url = \(url)")

            LocalStorageManager.shared.removeKey(.onboarding)

            // Process the URL similarly to the UIApplicationDelegate example.
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortcutItem = DeepLinkManager.shared.registerShortcutItem(shortcutItem: shortcutItem)
        completionHandler(handledShortcutItem)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        print("Incoming URL: \(url)")
        DeepLinkManager.shared.registerCalledURL(url: url)
    }
}
