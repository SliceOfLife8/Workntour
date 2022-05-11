//
//  SplashViewModel.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 11/5/22.
//

import Foundation
import Combine

/*
 Each implementation of Publisher can decide what to do with each new subscriber. It is a policy decision, not generally a design deficiency. Different Publishers make different decisions. Here are some examples:

 PassthroughSubject doesn't immediately publish anything.
 CurrentValueSubject immediately publishes its current value.
 NSObject.KeyValueObservingPublisher immediately publishes the current value of the observed property if and only if it is created with the .initial option.
 Published.Publisher (which is the type you get for an @Published property) publishes the current value of the property immediately.
 */

class SplashViewModel {
    // Service
    weak private var service: AuthorizationService?
    // Inputs
    let input: PassthroughSubject<Void, Never>
    // Outputs
    @Published private(set) var entries: [Entry]
    @Published private(set) var errorMessage: String?

    init(service: AuthorizationService = DataManager.shared) {
        self.service = service
        self.entries = []
        self.input = PassthroughSubject<Void, Never>()

        bindReloadToFetchConverter()
    }

    func bindReloadToFetchConverter() {
        input.compactMap { [weak self] _ in
            self?.service?.userRegistration()
        }
        .switchToLatest()
        .subscribe(on: RunLoop.main)
        .catch({ [weak self] error -> Just<[Entry]> in
            print("Error", error)
            self?.errorMessage = error.localizedDescription
            return Just([Entry]())
        })
                .assign(to: &$entries)
    }
}
