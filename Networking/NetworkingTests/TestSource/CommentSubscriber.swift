//
//  CommentSubscriber.swift
//  NetworkingTests
//
//  Created by Chris Petimezas on 1/5/22.
//

import Foundation
import Combine
@testable import Networking

class CommentSubscriber: Subscriber {
    typealias Input = CommentsResponse
    typealias Failure = ProviderError

    let publisher = PassthroughSubject<Input, Failure>()

    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }

    func receive(_ input: CommentsResponse) -> Subscribers.Demand {
        publisher.send(input)
        return Subscribers.Demand.unlimited
    }
    func receive(completion: Subscribers.Completion<ProviderError>) {
        publisher.send(completion: completion)
    }
}

