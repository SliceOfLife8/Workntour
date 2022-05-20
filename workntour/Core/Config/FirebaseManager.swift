//
//  FirebaseManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 20/5/22.
//

import FirebaseAnalytics
import FirebaseCrashlytics

enum AnalyticsEvent {
    case registration

    var value: String {
        switch self {
        case .registration:
            return "registration"
        }
    }
}

final class FirebaseManager {
    static let sharedInstance = FirebaseManager()

    // MARK: - Analytics
    func sendEvent(_ event: AnalyticsEvent, params: [String: Any]? = nil) {
        Analytics.logEvent(event.value, parameters: params)
    }

    func trackScreen(_ name: String) {
        let formattedName = name.replacingOccurrences(of: "VC", with: " Screen")
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: formattedName])
    }

    // MARK: - Crashlytics
    func recordCrash(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }

    func logCrash(_ crash: String) {
        Crashlytics.crashlytics().log(crash)
    }
}
