//
//  LocalStorageManagerTests.swift
//  SharedKitTests
//
//  Created by Chris Petimezas on 2/5/22.
//

import XCTest
@testable import SharedKit

class LocalStorageTests: XCTestCase {

    var sut: LocalStorageManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LocalStorageManager.shared
        sut.eraseAll()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testStoreDataToUserDefaults() {
        // Given
        let value = Bool.random()
        let key = LocalDataKey.allCases.randomElement() ?? .onboarding
        // Then
        sut.save(value, forKey: key, expirationDate: .oneWeek, withMethod: .userDefaults)
        let result = sut.retrieve(forKey: key, type: Bool.self)
        // When
        XCTAssertEqual(value, result)
    }

    func testStoreDataToFileManager() {
        // Given
        let value = UUID().uuidString
        let key = LocalDataKey.allCases.randomElement() ?? .onboarding
        // Then
        sut.save(value, forKey: key, expirationDate: .oneDay, withMethod: .nsKeyedArchiver)
        let result = sut.retrieve(forKey: key, withMethod: .nsKeyedArchiver, type: String.self)
        // When
        XCTAssertEqual(value, result)
    }

    func testExpirationDate() throws {
        // Given
        let value = arc4random()
        let key =  LocalDataKey.allCases.randomElement() ?? .onboarding
        let expirationDateKey = "keyExpiresIn - \(key)"
        let randomDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1..<100), to: Date())!
        // Then
        sut.save(value, forKey: key, expirationDate: .custom(randomDate), withMethod: .userDefaults)
        guard let result = sut.userDefaults.data(forKey: expirationDateKey) else {
            XCTFail("Cannot create a data object!")
            return
        }
        let date = try? JSONDecoder().decode(Date.self, from: result)
        // When
        XCTAssertEqual(randomDate, date)
    }

    func testNoDataReceivedFromUserDefaults() {
        // Given
        let key = LocalDataKey.allCases.randomElement() ?? .onboarding
        // Then
        let value = sut.retrieve(forKey: key, withMethod: .userDefaults, type: Bool.self)
        // When
        XCTAssertNil(value)
    }

    func testNoDataReceivedFromFileStorage() {
        // Given
        let key = LocalDataKey.allCases.randomElement() ?? .onboarding
        // Then
        let value = sut.retrieve(forKey: key, withMethod: .nsKeyedArchiver, type: Bool.self)
        // When
        XCTAssertNil(value)
    }

    func testSyncUserDefaultsData() {
        // Given
        let value = Double.random(in: 2.71828...3.14159)
        let key =  LocalDataKey.allCases.randomElement() ?? .onboarding
        // Then
        sut.save(value, forKey: key, expirationDate: .custom(Date()), withMethod: .userDefaults)
        wait(for: 0.5, withDescription: "Local data should be removed from UserDefaults!")
        sut.syncLocalData()
        // When
        XCTAssertNil(sut.userDefaults.data(forKey: key.rawValue))
    }

    func testSyncFileManagerData() {
        // Given
        let value = Double.random(in: 2.71828...3.14159)
        let key =  LocalDataKey.allCases.randomElement() ?? .onboarding
        // Then
        sut.save(value, forKey: key, expirationDate: .custom(Date()), withMethod: .nsKeyedArchiver)
        wait(for: 0.5, withDescription: "Local data should be removed from file system!")
        sut.syncLocalData()
        // When
        XCTAssertNil(sut.userDefaults.data(forKey: key.rawValue))
    }

    func testEraseAll() {
        // Given
        let key = LocalDataKey.onboarding
        let expirationKey = "keyExpiresIn - \(key.rawValue)"
        // Then
        sut.save("Eraser", forKey: key, expirationDate: .oneMonth, withMethod: .userDefaults)
        sut.eraseAll()
        // When
        XCTAssertNil(sut.userDefaults.data(forKey: key.rawValue))
        XCTAssertNil(sut.userDefaults.data(forKey: expirationKey))
    }

    func testRemoveKey() {
        // Given
        let key = LocalDataKey.onboarding
        // Then
        sut.save(UUID().uuidString, forKey: key, expirationDate: .oneMonth, withMethod: .userDefaults)
        sut.removeKey(key)
        // When
        XCTAssertNil(sut.userDefaults.data(forKey: key.rawValue))
    }

    func testUpdateKey() {
        // Given
        let value = true
        let key = LocalDataKey.onboarding
        // Then
        sut.save(value, forKey: key, expirationDate: .oneDay, withMethod: .nsKeyedArchiver)
        sut.update(newValue: false, forKey: key, expirationDate: .oneDay, withMethod: .nsKeyedArchiver)
        let newValue = sut.retrieve(forKey: key, withMethod: .nsKeyedArchiver, type: Bool.self)
        // When
        XCTAssertNotEqual(value, newValue)
    }

}
