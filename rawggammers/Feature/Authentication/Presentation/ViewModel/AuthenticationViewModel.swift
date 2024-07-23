//
//  AuthenticationViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import Combine


class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    private let repository: AuthenticationRepository = AuthenticationRepositoryImpl.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init(email: String, password: String, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.email = email
        self.password = password
        self.cancellables = cancellables
    }
    
    func login() {
        repository.login(email: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func register() {
        repository.register(email: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        repository.logout()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    
    func resetPassword() {
        repository.resetPassword(email: email)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func updateEmail() {
        repository.updateEmail(email: email)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func updatePassword() {
        repository.updatePassword(password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
}

