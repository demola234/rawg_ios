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
    func googleSignIn() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try await remoteDataSource.googleSignIn()
                    promise(.success("User signed in with Google successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func appleSignIn() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try await remoteDataSource.appleSignIn()
                    promise(.success("User signed in with Apple successfully"))
                } catch {
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
            Task {
                do {
                    let _: () = try await remoteDataSource.login(email: email, password: password)
                    promise(.success("User logged in successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func register(email: String, password: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try await remoteDataSource.register(email: email, password: password)
                    promise(.success("User registered successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try remoteDataSource.logout()
                    promise(.success("User logged out successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func resetPassword(email: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try await remoteDataSource.resetPassword(email: email)
                    promise(.success("Password reset email sent successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateEmail(email: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try await remoteDataSource.updateEmail(email: email)
                    promise(.success("Email updated successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updatePassword(password: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            Task {
                do {
                    let _: () = try await remoteDataSource.updatePassword(password: password)
                    promise(.success("Password updated successfully"))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}


