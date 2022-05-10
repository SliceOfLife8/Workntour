//
//  AuthorizationDataRequests.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 3/5/22.
//

import Combine
import Networking

class AuthorizationDataRequests {
    static let shared = AuthorizationDataRequests()

    private(set) var networking: Networking

    init(networking: Networking = Networking(),
         debugEnabled: Bool = true) {
        self.networking = networking
        self.networking.preference.isDebuggingEnabled = debugEnabled
    }

    func userRegistration() -> AnyPublisher<Entry, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registration,
            scheduler: DispatchQueue.main,
            class: Welcome.self)
            .compactMap { $0.entries.first }
            .eraseToAnyPublisher()
    }

}
