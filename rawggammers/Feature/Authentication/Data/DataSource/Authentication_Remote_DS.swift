//
//  Authentication_Remote_DS.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

/// Protocol defining methods for remote authentication operations.
protocol AuthenticationRemoteDataSource {
    
    /// Logs in a user with the specified email and password.
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password for the user.
    ///   - completion: A closure to be executed once the login attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Registers a new user with the specified email and password.
    /// - Parameters:
    ///   - email: The email address of the new user.
    ///   - password: The password for the new user.
    ///   - completion: A closure to be executed once the registration attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Logs out the current user.
    /// - Parameter completion: A closure to be executed once the logout attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Sends a password reset email to the specified email address.
    /// - Parameters:
    ///   - email: The email address of the user requesting a password reset.
    ///   - completion: A closure to be executed once the password reset attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Updates the email address of the currently authenticated user.
    /// - Parameters:
    ///   - email: The new email address for the user.
    ///   - completion: A closure to be executed once the email update attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func updateEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Updates the password of the currently authenticated user.
    /// - Parameters:
    ///   - password: The new password for the user.
    ///   - completion: A closure to be executed once the password update attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Initiates Google Sign-In.
    /// - Parameter completion: A closure to be executed once the Google Sign-In attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func googleSignIn(completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Initiates Apple Sign-In.
    /// - Parameter completion: A closure to be executed once the Apple Sign-In attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func appleSignIn(completion: @escaping (Result<Void, Error>) -> Void)
    
    /// Retrieves the registration type of the currently authenticated user.
    /// - Parameter completion: A closure to be executed once the registration type retrieval completes, containing a `Result` with either a `String` registration type or an `Error` on failure.
    func getUserRegistrationType(completion: @escaping (Result<String, Error>) -> Void)
    
    /// Retrieves the current user's login status and details.
    /// - Parameter completion: A closure to be executed once the user details retrieval completes, containing a `Result` with either a `UsersDataEntity` on success or an `Error` on failure.
    func getUserIsLoggedIn(completion: @escaping (Result<UsersDataEntity, Error>) -> Void)
    
    /// Initiates Twitter Sign-In.
    /// - Parameter completion: A closure to be executed once the Twitter Sign-In attempt completes, containing a `Result` with either `Void` on success or an `Error` on failure.
    func twitterSignIn(completion: @escaping (Result<Void, Error>) -> Void)
}

/// Implementation of the `AuthenticationRemoteDataSource` protocol.
struct AuthenticationRemoteDataSourceImpl: AuthenticationRemoteDataSource {
    
    static let shared = AuthenticationRemoteDataSourceImpl()
    
    private init() {}
    
    func getUserIsLoggedIn(completion: @escaping (Result<UsersDataEntity, Error>) -> Void) {
        Task {
            guard let currentUser = Auth.auth().currentUser else {
                completion(.failure(NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])))
                return
            }
            
            do {
                let user: Void? = try await currentUser.reload()
                
                let uid = currentUser.uid
                let email = currentUser.email ?? ""
                let username = currentUser.displayName ?? ""
                let profileImageURL = currentUser.photoURL?.absoluteString ?? ""
                let providerData = currentUser.providerData.first
                let provider = providerData?.providerID ?? ""
                let isLoggedIn = user != nil
        
                let usersDataEntity = UsersDataEntity(
                    uid: uid,
                    email: email,
                    username: username,
                    profileImageURL: profileImageURL,
                    isLoggedIn: isLoggedIn,
                    provider: provider
                )
                
                completion(.success(usersDataEntity))
            } catch {
                print("Reload error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func getUserRegistrationType(completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])))
            return
        }
        
        completion(.success(user.providerData.first?.providerID ?? ""))
    }

    func googleSignIn(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let signInCredentials = try await signInGoogle()
                let userDetails = try await Auth.auth().signIn(with: signInCredentials)
                
                UserManager.shared.createNewUser(
                    id: userDetails.user.uid,
                    email: userDetails.user.email ?? "",
                    name: userDetails.user.displayName ?? "",
                    authType: "google.com",
                    photoUrl: userDetails.user.photoURL?.absoluteString ?? "", completion: { result in
                        switch result {
                        case .success:
                            print("User signed in with Google successfully: \(userDetails.user.uid)")
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
                
                print("User signed in with Google successfully: \(userDetails.user.uid)")
                completion(.success(()))
            } catch {
                print("Google sign in error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func signInGoogle() async throws -> AuthCredential {
        guard let topVC = await Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let result = result else {
                        continuation.resume(throwing: URLError(.cannotFindHost))
                        return
                    }
                    
                    guard let idToken = result.user.idToken?.tokenString else {
                        continuation.resume(throwing: URLError(.cannotFindHost))
                        return
                    }
                    
                    let accessToken = result.user.accessToken.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                    
                    continuation.resume(returning: credential)
                }
            }
        }
    }
    
    func appleSignIn(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let signInWithAppleHelper = await AppleSignInHelper()
            do {
                let userDetails = try await signInWithAppleHelper.startSignWithAppleFlow()
                
                UserManager.shared.createNewUser(
                    id: userDetails.uid,
                    email: userDetails.email,
                    name: userDetails.fullName,
                    authType: "apple.com",
                    photoUrl: userDetails.photoURL?.absoluteString ?? "", completion: { result in
                        switch result {
                        case .success:
                            print("User signed in with Apple successfully")
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
                
                print("User signed in with Apple successfully")
                completion(.success(()))
            } catch {
                print("Apple sign-in error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
                
                print("User logged in successfully: \(authDataResult.user.uid)")
                completion(.success(()))
            } catch {
                print("Login error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                
                UserManager.shared.createNewUser(
                    id: authDataResult.user.uid,
                    email: email,
                    name: "",
                    authType: "email",
                    photoUrl: "",
                    completion: { result in
                        switch result {
                        case .success:
                            print("User registered successfully: \(authDataResult.user.uid)")
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
                
                print("User registered successfully: \(authDataResult.user.uid)")
                completion(.success(()))
            } catch {
                print("Registration error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let user = Auth.auth().currentUser
            print("User provider: \(String(describing: user?.providerData.first?.providerID))")
            if user?.providerData.first?.providerID == "apple.com" {
                try Auth.auth().signOut()
                completion(.success(()))
                return
            } else if user?.providerData.first?.providerID == "google.com" {
                GIDSignIn.sharedInstance.signOut()
                completion(.success(()))
                return
            } else if user?.providerData.first?.providerID == "twitter.com" {
                try Auth.auth().signOut()
                completion(.success(()))
                return
            } else  {
                try Auth.auth().signOut()
                print("User logged out successfully")
                completion(.success(()))
            }
            
        } catch {
            print("Logout error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                print("Password reset email sent successfully")
                completion(.success(()))
            } catch {
                print("Password reset error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func updateEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            guard let user = Auth.auth().currentUser else {
                completion(.failure(NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])))
                return
            }
            
            do {
                try await user.sendEmailVerification()
                print("Email updated successfully")
                completion(.success(()))
            } catch {
                print("Update email error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            guard let user = Auth.auth().currentUser else {
                completion(.failure(NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])))
                return
            }
            
            do {
                try await user.updatePassword(to: password)
                print("Password updated successfully")
                completion(.success(()))
            } catch {
                print("Update password error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func twitterSignIn(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let twitterSignInHelper = await XSignInHelper()
            
            do {
                let userDetails = try await twitterSignInHelper.signInWithTwitter()
                
                UserManager.shared.createNewUser(
                    id: userDetails.id,
                    email: userDetails.email,
                    name: userDetails.fullName,
                    authType: "twitter.com",
                    photoUrl: userDetails.photoURL?.absoluteString ?? "",
                    completion: { result in
                        switch result {
                        case .success:
                            print("User signed in with Twitter successfully")
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
                
                print("User signed in with Twitter successfully")
                completion(.success(()))
            } catch {
                print("Twitter sign in error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
