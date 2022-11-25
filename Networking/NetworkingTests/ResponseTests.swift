//
//  ResponseTests.swift
//  NetworkingTests
//
//  Created by Chris Petimezas on 1/5/22.
//

import XCTest
@testable import Networking

final class ResponseTests: XCTestCase { }

// MARK: - Tests
extension ResponseTests {

    func testResponse() {
        let testURL = URL(string: "https://github.com/SliceOfLife8/Workntour")!
        let testStatusCode = 200
        let testHeaderFields: [String: String] = ["Test": "Value"]
        let testData = "Some Test Data".data(using: .utf8)!
        let response = Response(urlResponse: HTTPURLResponse(url: testURL,
                                                             statusCode: testStatusCode,
                                                             httpVersion: nil,
                                                             headerFields: testHeaderFields)!,
                                data: testData)

        XCTAssertEqual(response.statusCode, testStatusCode)
        XCTAssertEqual(response.data, testData)
        XCTAssertEqual(response.localizedStatusCodeDescription, HTTPURLResponse.localizedString(forStatusCode: testStatusCode))
    }
}
