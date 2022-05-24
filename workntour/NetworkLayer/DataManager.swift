//
//  DataManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Combine
import Networking

/// Data Manager acts as a middle layer (abstraction) between the service(s) and our application.
/// ViewModels are responsible to communite with this layer and pass the data back to Views.
class DataManager {
    static let shared = DataManager()

    private(set) var networking: Networking

    init(networking: Networking = Networking(),
         debugEnabled: Bool = true) {
        self.networking = networking
        self.networking.preference.isDebuggingEnabled = debugEnabled
    }
}

extension DataManager: AuthorizationService {

    func userRegistration(traveler: Traveler) -> AnyPublisher<NoReply, ProviderError> {
        return networking.request(
            with: AuthorizationRouter.registerTraveler(traveler),
            scheduler: DispatchQueue.main,
            class: NoReply.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }

}
