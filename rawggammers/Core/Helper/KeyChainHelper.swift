//
//  KeychainHelper.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 31/07/2024.
//

import Security
import Foundation

/// A helper class for interacting with the iOS Keychain to store, retrieve, and delete data securely.
class KeychainHelper {
    
    /// The shared instance of `KeychainHelper`.
    static let shared = KeychainHelper()
    
    /// Saves data to the Keychain.
    ///
    /// - Parameters:
    ///   - data: The data to be saved.
    ///   - service: The service identifier for the Keychain item.
    ///   - account: The account identifier for the Keychain item.
    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Reads data from the Keychain.
    ///
    /// - Parameters:
    ///   - service: The service identifier for the Keychain item.
    ///   - account: The account identifier for the Keychain item.
    /// - Returns: The data associated with the given service and account, or `nil` if the data could not be found.
    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }
    
    /// Deletes data from the Keychain.
    ///
    /// - Parameters:
    ///   - service: The service identifier for the Keychain item.
    ///   - account: The account identifier for the Keychain item.
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
