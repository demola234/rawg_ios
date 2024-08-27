//
//  SettingsDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine

/// Protocol defining the operations for remote data source related to user settings.
///
/// This protocol specifies the methods for interacting with remote data sources to get and update user profile information.
protocol SettingsRemoteDataSource {
    /// Retrieves the profile image for the current user.
    /// - Parameter completion: A closure that returns the result of the operation. The result is either a `User` object or an `Error`.
    func getProfileImage(completion: @escaping (Result<User, Error>) -> Void)
    
    /// Updates the profile image for the current user.
    /// - Parameter image: The URL or identifier of the image to set as the profile picture.
    /// - Parameter completion: A closure that returns the result of the operation. The result is either `Void` or an `Error`.
    func updateProfileImage(image: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Updates the profile name for the current user.
    /// - Parameter name: The new name to set for the profile.
    /// - Parameter completion: A closure that returns the result of the operation. The result is either `Void` or an `Error`.
    func updateProfileName(name: String, completion: @escaping (Result<Void, Error>) -> Void)
}

/// Implementation of `SettingsRemoteDataSource` using Firebase Firestore and UserManager.
///
/// This struct provides concrete implementations of the methods defined in the `SettingsRemoteDataSource` protocol.
struct SettingsRemoteDataSourceImpl: SettingsRemoteDataSource {
    
    /// Shared instance of `SettingsRemoteDataSourceImpl`.
    static let shared = SettingsRemoteDataSourceImpl()
    
    private init() {}
    
    
    /// Retrieves the profile image for the current user.
    /// - Parameter completion: A closure that returns the result of the operation. The result is either a `User` object or an `Error`.
    func getProfileImage(completion: @escaping (Result<User, Error>) -> Void) {
        UserManager.shared.getUser() { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Updates the profile image for the current user.
    /// - Parameter image: The URL or identifier of the image to set as the profile picture.
    /// - Parameter completion: A closure that returns the result of the operation. The result is either `Void` or an `Error`.
    func updateProfileImage(image: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("SettingsRemoteDataSourceImpl: \(image)")
        UserManager.shared.uploadImageToFirebase(image: image) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Updates the profile name for the current user.
    /// - Parameter name: The new name to set for the profile.
    /// - Parameter completion: A closure that returns the result of the operation. The result is either `Void` or an `Error`.
    func updateProfileName(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        UserManager.shared.updateProfileName(name: name) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
