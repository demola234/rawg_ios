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
    @Published var errorMessage: String?
    @Published var isLogged: Bool = false
    @Published var isLoading: Bool = false
    
    private let repository: AuthenticationRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: AuthenticationRepository = AuthenticationRepositoryImpl.shared) {
        self.repository = repository
    }
    
    func googleSignIn() {
//        isLoading = true
        self.errorMessage = ""
        repository.googleSignIn()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.isLogged = true
                    break
                case .failure(let error):
                    self.isLoading = false
                    self.isLogged = false
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func appleSignIn() {
        self.errorMessage = ""
        repository.appleSignIn()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func login() {
        isLoading = true
        repository.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func register() {
        isLoading = true
        repository.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    break
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        repository.logout()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { message in
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    
    func resetPassword() {
        repository.resetPassword(email: email)
            .receive(on: DispatchQueue.main)
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
            .receive(on: DispatchQueue.main)
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
            .receive(on: DispatchQueue.main)
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

