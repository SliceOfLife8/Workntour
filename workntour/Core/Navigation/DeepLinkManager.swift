//
//  DeepLinkManager.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import Foundation
import UIKit

enum DeepLinkRoute {
    case dashboard

    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.host == "www.example.com",
            let query = components.queryItems
            else { return nil }
        switch components.path {
        case "/blabla/dashboard": self = .dashboard
        default: return nil
        }
    }

    init?(shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        // add cases about shortcut items
        default: return nil
        }
    }

}

class DeepLinkingUserInfo: NSObject {
    var deepLinkUrl: URL?
    var notificationUserInfo: [String: Any]?

    init(deepLinkUrl: URL? = nil, pushInfo: [String: Any]? = nil) {
        self.notificationUserInfo = pushInfo
        self.deepLinkUrl = deepLinkUrl
    }
}

protocol DeepLinkManagerDelegate: AnyObject {
    func redirect(to route: DeepLinkRoute)
}

class DeepLinkManager {

    var operationQueue = OperationQueue()
    weak var delegate: DeepLinkManagerDelegate?

    var isSuspended: Bool {
        get { return self.operationQueue.isSuspended }
        set {
            self.operationQueue.isSuspended = newValue
        }
    }

    static let shared = DeepLinkManager()

    fileprivate init() {
        self.operationQueue.maxConcurrentOperationCount = 1
        self.isSuspended = true
    }

    @discardableResult
    func registerRoute(route: DeepLinkRoute?) -> Bool {
        if let route = route {
            self.operationQueue.addOperation {
                DispatchQueue.main.async {
                    self.delegate?.redirect(to: route)
                }
            }
            return true
        }
        return false
    }

    @discardableResult
    func registerCalledURL(url: URL) -> Bool {
        return self.registerRoute(route: DeepLinkRoute(url: url))
    }

    @discardableResult
    func registerShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        return self.registerRoute(route: DeepLinkRoute(shortcutItem: shortcutItem))
    }

}
