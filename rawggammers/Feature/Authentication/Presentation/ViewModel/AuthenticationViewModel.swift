//
//  AuthenticationViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import Combine

/// A view model responsible for managing authentication-related operations and state.
/// It handles user login, registration, password reset, and social media sign-ins.
class AuthenticationViewModel: ObservableObject {
    /// The email address entered by the user.
    @Published var email: String = ""
    
    /// The password entered by the user.
    @Published var password: String = ""
    
    /// A boolean indicating whether to keep the user logged in.
    @Published var keepMeLoggedIn: Bool = false
    
    /// Details about the currently logged-in user.
    @Published var userDetails: UsersDataEntity?
    
    /// An optional error message to be displayed to the user.
    @Published var errorMessage: String?
    
    /// A boolean indicating whether the user is logged in.
    @Published var isLogged: Bool = false
    
    /// A boolean indicating whether a network request is in progress.
    @Published var isLoading: Bool = false
    
    private let repository: AuthenticationRepository
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes the view model with a repository for authentication operations.
    /// - Parameter repository: The repository used for authentication operations. Defaults to `AuthenticationRepositoryImpl.shared`.
    init(repository: AuthenticationRepository = AuthenticationRepositoryImpl.shared) {
        self.repository = repository
        getUserIsLoggedIn()
    }
    
    /// A computed property that validates the email address format.
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// A computed property that validates the password based on various criteria.
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
    
    /// Checks if the user is logged in by querying the repository.
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
                self.isLogged = userDetails.isLoggedIn
            }
            .store(in: &cancellables)
    }
    
    /// Retrieves the user's registration type from the repository.
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
    
    /// Signs in the user with Google authentication.
    func googleSignIn() {
        self.errorMessage = ""
        repository.googleSignIn()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.isLogged = true
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
    
    /// Signs in the user with Twitter authentication.
    func twitterSignIn() {
        self.errorMessage = ""
        repository.twitterSignIn()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.isLogged = true
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
    
    /// Signs in the user with Apple authentication.
    func appleSignIn() {
        self.errorMessage = ""
        repository.appleSignIn()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.isLogged = true
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
    
    /// Logs in the user with the provided email and password.
    func login() {
        isLoading = true
        repository.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    self.isLogged = true
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
    
    /// Registers a new user with the provided email and password.
    func register() {
        isLoading = true
        repository.register(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { message in
                self.isLogged = true
                print("Message: \(message)")
            }
            .store(in: &cancellables)
    }
    
    /// Logs out the currently logged-in user.
    func logout() {
        print("Logging out...")
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
    
    /// Resets the password for the user associated with the provided email address.
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
    
    /// Updates the email address of the currently logged-in user.
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
    
    /// Updates the password of the currently logged-in user.
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
