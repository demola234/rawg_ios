//
//  AuthenticationRepositoryImpl.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import Combine
import FirebaseAuth

struct AuthenticationRepositoryImpl: AuthenticationRepository {
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
    
    static let shared = AuthenticationRepositoryImpl()
    
    private init() {}
    
    private let remoteDataSource: AuthenticationRemoteDataSource = AuthenticationRemoteDataSourceImpl.shared
    
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
}
