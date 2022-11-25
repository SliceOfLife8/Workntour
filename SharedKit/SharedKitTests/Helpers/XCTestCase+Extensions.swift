//
//  XCTestCase+Extensions.swift
//  SharedKit
//
//  Created by Chris Petimezas on 2/5/22.
//

import XCTest

extension XCTestCase {
    func wait(for duration: TimeInterval, withDescription desc: String = "Waiting") {
        let waitExpectation = expectation(description: desc)

        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }

        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}
