//
//  AuthenticationRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import Combine


// MARK: - AuthenticationRepository
protocol AuthenticationRepository {
    func login(email: String, password: String) -> AnyPublisher<String, Error>
    func register(email: String, password: String) -> AnyPublisher<String, Error>
    func logout() -> AnyPublisher<String, Error>
    func resetPassword(email: String) -> AnyPublisher<String, Error>
    func updateEmail(email: String) -> AnyPublisher<String, Error>
    func updatePassword(password: String) -> AnyPublisher<String, Error>
    func googleSignIn() -> AnyPublisher<String, Error>
    func appleSignIn() -> AnyPublisher<String, Error>
    func getUserRegistrationType() -> AnyPublisher<String, Error>
    func getUserIsLoggedIn() -> AnyPublisher<Bool, Error>
}
