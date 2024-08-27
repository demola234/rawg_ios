//
//  SettingsRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//

import Foundation
import Combine

/// Implementation of the `SettingsRepository` protocol.
///
/// This struct handles interactions with remote data sources to manage user settings, such as retrieving and updating profile information.
struct SettingsRepositoryImpl: SettingsRepository {
    
    /// Shared instance of `SettingsRepositoryImpl`.
    static let shared = SettingsRepositoryImpl()
    
    private init() {}
    
    private let remoteDataSource: SettingsRemoteDataSource = SettingsRemoteDataSourceImpl.shared
    
    /// Retrieves the profile image of the current user.
    /// - Returns: An `AnyPublisher` that emits a `User` object on success or an `Error` on failure.
    func getProfileImage() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            remoteDataSource.getProfileImage { result in
                switch result {
                case .success(let profileImage):
                    promise(.success(profileImage))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Updates the profile image of the current user.
    /// - Parameter image: The URL or identifier of the image to set as the profile picture.
    /// - Returns: An `AnyPublisher` that emits `Void` on success or an `Error` on failure.
    func updateProfileImage(image: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            remoteDataSource.updateProfileImage(image: image) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Updates the profile name of the current user.
    /// - Parameter name: The new name to set for the profile.
    /// - Returns: An `AnyPublisher` that emits `Void` on success or an `Error` on failure.
    func updateProfileName(name: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            remoteDataSource.updateProfileName(name: name) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
