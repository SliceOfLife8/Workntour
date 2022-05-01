//
//  LocalStorageManager.swift
//  workntour
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation

enum LocalDataKey: String, CaseIterable {
    case onboarding
}

enum DataPersistenceMethod {
    case nsKeyedArchiver
    case userDefaults
}

enum DataExpirationDate {
    case oneDay
    case threeDays
    case oneWeek
    case oneMonth
    case custom(Date)
}

// This class is responsible to store local data with security levels & date expiration
final class LocalStorageManager {
    static let shared = LocalStorageManager()

    let userDefaults = UserDefaults.standard
    let fileManager = FileManager.default

    /**
     Save func parameters
     - Parameter value: A generic value T in order to store all types of data.
     - Parameter key: This key is also refers to the key we are storing. Instead of using a 'String' value we need an enum case in order to monitoring the expiration date of all storage values.
     - Parameter expirationDate: This refers to the date we want the key to be expired. If we don't want to be expired we have to pass it as none value.
     - Parameter method: This refers to the ways we are currently storing local data.
     */
    public func save<T: Codable>(
        _ value: T,
        forKey key: LocalDataKey,
        expirationDate: DataExpirationDate? = nil,
        withMethod method: DataPersistenceMethod) {

            switch method {
            case .nsKeyedArchiver:
                archive(value, forKey: key.rawValue)
            case .userDefaults:
                storeInUserDefaults(value, forKey: key.rawValue)
            }

            if let date = expirationDate {
                saveExpirationDate(key.rawValue, expirationDate: date)
            }
        }

    private func saveExpirationDate(_ key: String, expirationDate: DataExpirationDate) {
        let expirationDateKey = "keyExpiresIn - \(key)"
        let value: Date

        switch expirationDate {
        case .oneDay:
            value = Date().dayAfter
        case .threeDays:
            value = Date().dayAfterThreeDays
        case .oneWeek:
            value = Date().dayAfterWeek
        case .oneMonth:
            value = Date().dayAfterMonth
        case .custom(let date):
            value = date
        }

        storeInUserDefaults(value, forKey: expirationDateKey)
    }

    /**
     Retrieve func parameters
     - Parameter key: This key is also refers to the key we are storing. Instead of using a 'String' value we need an enum case in order to monitoring the expiration date of all storage values.
     - Parameter method: This refers to the ways we are currently storing local data.
     - Parameter type: We need to cast generic 'T', so here we pass the type we want to cast. f.e. Bool.self
     */
    public func retrieve<T: Codable>(
        forKey key: LocalDataKey,
        withMethod method: DataPersistenceMethod = .userDefaults,
        type: T.Type) -> T? {
            // Remove keys when it's necessary
            removeKeyIfExpired(key)

            switch method {
            case .nsKeyedArchiver:
                return unarchive(forKey: key.rawValue, type)
            case .userDefaults:
                return retrieveFromUserDefaults(forKey: key.rawValue, type)
            }
        }

    /**
     Save func parameters
     - Parameter value: A new generic value in order to replace the old one.
     - Parameter key: This key is also refers to the key we are storing. Instead of using a 'String' value we need an enum case in order to monitoring the expiration date of all storage values.
     - Parameter expirationDate: This refers to the date we want the key to be expired. If we don't want to be expired we have to pass it as none value.
     - Parameter method: This refers to the ways we are currently storing local data.
     */
    public func update<T: Codable>(
        newValue value: T,
        forKey key: LocalDataKey,
        expirationDate: DataExpirationDate?,
        withMethod method: DataPersistenceMethod = .userDefaults) {
            // Delete & create new record for the key
            clearPersistentStorage(forKey: key, expirationKey: "keyExpiresIn - \(key.rawValue)")

            save(value, forKey: key, expirationDate: expirationDate, withMethod: method)
        }

    /**
     syncLocalData func
     We need to iterate through all enum localDataKeys & check if we have records in userDefaults storage about expiration data.
     So, we can easily delete obsolete records.
     */
    public func syncLocalData() {
        for value in LocalDataKey.allCases {
            removeKeyIfExpired(value)
        }
    }

}

// MARK: - UserDefaults
extension LocalStorageManager {
    private func storeInUserDefaults<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else {
            assertionFailure("Cannot create a json representation of \(value)")
            return
        }
        userDefaults.set(data, forKey: key)
    }

    private func retrieveFromUserDefaults<T: Codable>(forKey key: String, _ type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - NSKeyedArchiver
extension LocalStorageManager {
    private func archive<T: Codable>(_ value: T, forKey key: String) {
        guard let dataToBeArchived = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true),
              let archiveURL = archiveURL(key)
        else {
            assertionFailure("Unable to archive custom object")
            return
        }

        try? dataToBeArchived.write(to: archiveURL)
    }

    private func unarchive<T: Codable>(forKey key: String, _ type: T.Type) -> T? {
        guard let archiveURL = archiveURL(key),
              let archivedData = try? Data(contentsOf: archiveURL),
              let customObject = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData)) as? T
        else {
            return nil
        }

        return customObject
    }

    private func archiveURL(_ path: String) -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return nil
        }

        return documentURL.appendingPathComponent(path)
    }

    private func removeFileItem(_ path: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(path)
        try? fileManager.removeItem(atPath: destinationPath)
    }
}

// MARK: - Remove from persistence storage
extension LocalStorageManager {
    private func removeKeyIfExpired(_ dataKey: LocalDataKey) {
        let expirationKey = "keyExpiresIn - \(dataKey.rawValue)"
        guard let expirationDate = retrieveFromUserDefaults(forKey: expirationKey, Date.self) else {
            return
        }

        if Date().isGreaterThan(expirationDate) {
            clearPersistentStorage(forKey: dataKey, expirationKey: expirationKey)
        }
    }

    /**
     clearPersistentStorage func parameters
     - Parameter key: This key is also refers to the key we are storing. Instead of using a 'String' value we need an enum case in order to monitoring the expiration date of all storage values.
     - Parameter expirationKey: This refers to the expirationKey which is related with the date that 'key' is supposed to expired.
     */
    private func clearPersistentStorage(
        forKey key: LocalDataKey,
        expirationKey: String) {
            // Clear the unused persistent storage
            userDefaults.removeObject(forKey: expirationKey)
            userDefaults.removeObject(forKey: key.rawValue)
            removeFileItem(key.rawValue)
        }

    func eraseAll() {
        LocalDataKey.allCases.forEach { dataKey in
            let expirationKey = "keyExpiresIn - \(dataKey.rawValue)"

            clearPersistentStorage(forKey: dataKey, expirationKey: expirationKey)
        }
    }

    func removeKey(_ key: LocalDataKey) {
        let expirationKey = "keyExpiresIn - \(key.rawValue)"

        clearPersistentStorage(forKey: key, expirationKey: expirationKey)
    }
}
