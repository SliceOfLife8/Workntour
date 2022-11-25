//
//  CompletionBlockTests.swift
//  NetworkingTests
//
//  Created by Chris Petimezas on 1/5/22.
//

import XCTest
@testable import Networking

final class CompletionBlockTests: XCTestCase {
    var testClass: TestClass!
    
    override func setUp() {
        testClass = TestClass()
    }
    
    override func tearDown() {
        testClass = nil
    }
    
    func testFetchPosts() {
        let exp = expectation(description: "testFetchPosts")
        testClass.fetchPosts { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testFetchPostById() {
        let exp = expectation(description: "testFetchPostById")
        testClass.fetchPostById { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testCreatePost() {
        let exp = expectation(description: "testCreatePost")
        testClass.createPost { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testUpdatePostWithPut() {
        let exp = expectation(description: "testUpdatePostWithPut")
        testClass.updatePostWithPut { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testUpdatePostWithPatch() {
        let exp = expectation(description: "testUpdatePostWithPatch")
        testClass.updatePostWithPatch { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testFetchPostWithUserId() {
        let exp = expectation(description: "testFetchPostWithUserId")
        testClass.fetchPostsByUserId { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
    
    func testFetchCommentsWithPostId() {
        let exp = expectation(description: "testFetchPostWithUserId")
        testClass.fetchCommentsWithPostId { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
                
            }
        }
        wait(for: [exp], timeout: 5)
    }
    func testDeletePost() {
        let exp = expectation(description: "testFetchPostWithUserId")
        testClass.deletePost { result in
            switch result {
            case .success:
                exp.fulfill()
            case .failure(let error):
                XCTFail("Onur: \(error.errorDescription)")
            }
        }
        wait(for: [exp], timeout: 5)
    }
}
