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
    @Published var keepMeLoggedIn: Bool = false
    @Published var userDetails: UsersDataEntity?
    @Published var errorMessage: String?
    @Published var isLogged: Bool = false
    @Published var isLoading: Bool = false
    
    private let repository: AuthenticationRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: AuthenticationRepository = AuthenticationRepositoryImpl.shared) {
        self.repository = repository
        getUserIsLoggedIn()
    }
    
    // Validate email
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isValidPassword: String {
        if password.isEmpty {
            return "Password cannot be empty."
        } else if password.count < 6 {
            return "Password must be at least 6 characters long."
        } else if !password.contains(where: { $0.isUppercase }) {
            return "Password must contain at least one uppercase letter."
        } else if !password.contains(where: { $0.isLowercase }) {
            return "Password must contain at least one lowercase letter."
        } else if !password.contains(where: { $0.isNumber }) {
            return "Password must contain at least one number."
        } else if !password.contains(where: { "!@#$%^&*()_+=-".contains($0) }) {
            return "Password must contain at least one special character."
        }
        return ""
    }
    
    func getUserIsLoggedIn() {
        repository.getUserIsLoggedIn()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error Authentication 🔥: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    
                }
            } receiveValue: { userDetails in
                self.userDetails = userDetails
                if userDetails.isLoggedIn {
                    self.isLogged = true
                } else {
                    self.isLogged = false
                }
            }
            .store(in: &cancellables)
    }
    
    func getUserRegistrationType() {
        repository.getUserRegistrationType()
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
    
    func googleSignIn() {
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
    
    func twitterSignIn() {
        self.errorMessage = ""
        repository.twitterSignIn()
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
    
    func login() {
        isLoading = true
        repository.login(email: email, password: password)
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
    
    func register() {
        isLoading = true
        repository.register(email: email, password: password)
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
                self.isLogged = false
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
