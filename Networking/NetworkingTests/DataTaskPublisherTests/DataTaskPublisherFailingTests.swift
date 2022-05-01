//
//  DataTaskPublisherFailingTests.swift
//  NetworkingTests
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import XCTest
@testable import Networking

final class DataTaskPublisherFailingTests: XCTestCase {

    var testClass: TestClass!

    override func setUp() {
        super.setUp()
        testClass = TestClass()
    }

    override func tearDown() {
        testClass = nil
        super.tearDown()
    }
}


// MARK: - Tests
extension DataTaskPublisherFailingTests {

    func testFetchPostById() {

        let exp = expectation(description: "testFetchPostById")
        testClass.fetchPostById(1231234123)
        guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
        let cancellable = testSubscriber.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("Error:", error.errorDescription)
                exp.fulfill()
            case .finished:
                exp.fulfill()
            }
        }, receiveValue: { response in
            XCTFail("Onur: \(response)")
        })
        wait(for: [exp], timeout: 5)
    }

    func testUpdatePostWithPut() {
        let exp = expectation(description: "testUpdatePostWithPut")
        testClass.updatePostWithPut(postId: -52491293012, userId: -1293419230123, title: "", body: "")
        guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
        let cancellable = testSubscriber.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("Error:", error.errorDescription)
                exp.fulfill()
            case .finished:
                exp.fulfill()
            }
        }, receiveValue: { response in
            XCTFail("Onur: \(response)")
        })
        wait(for: [exp], timeout: 5)
    }

    func testUpdatePostWithPatch() {
        let exp = expectation(description: "testUpdatePostWithPatch")
        testClass.updatePostWithPatch(postId: 1293419230123, title: "")
        guard let testSubscriber = testClass.postSubscriber else { return assertionFailure() }
        let cancellable = testSubscriber.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print("Error:", error.errorDescription)
                exp.fulfill()
            case .finished:
                exp.fulfill()
            }
        }, receiveValue: { response in
            XCTFail("Onur: \(response)")
        })
        wait(for: [exp], timeout: 5)
    }

}
