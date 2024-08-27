//
//  AuthenticationRepositoryImpl.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import Combine
import FirebaseAuth

/// Implementation of the `AuthenticationRepository` that interacts with remote data sources for user authentication.
///
/// This implementation provides methods for various authentication tasks such as signing in with Google, Apple, or Twitter,
/// registering, logging in, logging out, resetting passwords, and updating user details. Each method returns a `Publisher`
/// that emits the result of the operation and handles potential errors.
///
/// - Note: This class uses `Future` to wrap asynchronous operations into a `Publisher` and relies on `AuthenticationRemoteDataSource`
///   for the actual network operations.
///
/// - Singleton: `shared` is a static instance of `AuthenticationRepositoryImpl` for shared usage.
struct AuthenticationRepositoryImpl: AuthenticationRepository {

    static let shared = AuthenticationRepositoryImpl()
    
    private init() {}
    
    private let remoteDataSource: AuthenticationRemoteDataSource = AuthenticationRemoteDataSourceImpl.shared

    /// Checks if a user is currently logged in.
    ///
    /// - Returns: A publisher emitting a `UsersDataEntity` if the user is logged in, or an `Error` if the operation fails.
    func getUserIsLoggedIn() -> AnyPublisher<UsersDataEntity, Error> {
        return Future<UsersDataEntity, Error> { promise in
            AuthenticationRemoteDataSourceImpl.shared.getUserIsLoggedIn { result in
                switch result {
                case .success(let isLoggedIn):
                    promise(.success(isLoggedIn))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Retrieves the user's registration type.
    ///
    /// - Returns: A publisher emitting a `String` representing the registration type, or an `Error` if the operation fails.
    func getUserRegistrationType() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            AuthenticationRemoteDataSourceImpl.shared.getUserRegistrationType { result in
                switch result {
                case .success(let registrationType):
                    promise(.success(registrationType))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Signs in the user with Google.
    ///
    /// - Returns: A publisher emitting a success message upon successful sign-in, or an `Error` if the operation fails.
    func googleSignIn() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            AuthenticationRemoteDataSourceImpl.shared.googleSignIn { result in
                switch result {
                case .success:
                    promise(.success("User signed in with Google successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Signs in the user with Apple.
    ///
    /// - Returns: A publisher emitting a success message upon successful sign-in, or an `Error` if the operation fails.
    func appleSignIn() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            AuthenticationRemoteDataSourceImpl.shared.appleSignIn { result in
                switch result {
                case .success:
                    promise(.success("User signed in with Apple successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Logs in the user with an email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    ///
    /// - Returns: A publisher emitting a success message upon successful login, or an `Error` if the operation fails.
    func login(email: String, password: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            remoteDataSource.login(email: email, password: password) { result in
                switch result {
                case .success:
                    promise(.success("User logged in successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Registers a new user with an email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    ///
    /// - Returns: A publisher emitting a success message upon successful registration, or an `Error` if the operation fails.
    func register(email: String, password: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            remoteDataSource.register(email: email, password: password) { result in
                switch result {
                case .success:
                    promise(.success("User registered successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Logs out the current user.
    ///
    /// - Returns: A publisher emitting a success message upon successful logout, or an `Error` if the operation fails.
    func logout() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            do {
                remoteDataSource.logout { result in
                    switch result {
                    case .success:
                        promise(.success("User logged out successfully"))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Sends a password reset email to the specified email address.
    ///
    /// - Parameters:
    ///   - email: The email address to send the password reset email to.
    ///
    /// - Returns: A publisher emitting a success message upon successful email sending, or an `Error` if the operation fails.
    func resetPassword(email: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            remoteDataSource.resetPassword(email: email) { result in
                switch result {
                case .success:
                    promise(.success("Password reset email sent successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Updates the user's email address.
    ///
    /// - Parameters:
    ///   - email: The new email address for the user.
    ///
    /// - Returns: A publisher emitting a success message upon successful email update, or an `Error` if the operation fails.
    func updateEmail(email: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            remoteDataSource.updateEmail(email: email) { result in
                switch result {
                case .success:
                    promise(.success("Email updated successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Updates the user's password.
    ///
    /// - Parameters:
    ///   - password: The new password for the user.
    ///
    /// - Returns: A publisher emitting a success message upon successful password update, or an `Error` if the operation fails.
    func updatePassword(password: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            remoteDataSource.updatePassword(password: password) { result in
                switch result {
                case .success:
                    promise(.success("Password updated successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    /// Signs in the user with Twitter.
    ///
    /// - Returns: A publisher emitting a success message upon successful sign-in, or an `Error` if the operation fails.
    func twitterSignIn() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            remoteDataSource.twitterSignIn{ result in
                switch result {
                case .success:
                    promise(.success("User signed in with Twitter successfully"))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
