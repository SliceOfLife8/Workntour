//
//  DeepLinkManager.swift
//  workntour
//
//  Created by Chris Petimezas on 1/5/22.
//

import Foundation
import UIKit

enum DeepLinkRoute {
    case forgotPasswordVerification(token: String)
    case verifyRegistration(token: String)

    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              components.host?.oneOf(other: "workntour.com", "workntour.page.link") == true,
              let innerLink = components.queryItems?.first?.value,
              let innerURL = URLComponents(string: innerLink)
        else {
            return nil
        }

        // Verification related deep links
        if innerURL.path == "/verification",
           let query = innerURL.queryItems?.first,
           let queryValue = query.value {
            switch query.name {
            case "forgotPasswordToken":
                self = .forgotPasswordVerification(token: queryValue)
            case "emailVerificationToken":
                self = .verifyRegistration(token: queryValue)
            default: return nil
            }
        }
        else {
            return nil
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

    static let shared = DeepLinkManager()

    var operationQueue = OperationQueue()
    weak var delegate: DeepLinkManagerDelegate?

    var isSuspended: Bool {
        get { return self.operationQueue.isSuspended }
        set {
            self.operationQueue.isSuspended = newValue
        }
    }

    fileprivate init() {
        self.operationQueue.maxConcurrentOperationCount = 1
        self.isSuspended = false
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
