//
//  Authentication_Remote_DS.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn


protocol AuthenticationRemoteDataSource {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func googleSignIn(completion: @escaping (Result<Void, Error>) -> Void)
    func appleSignIn(completion: @escaping (Result<Void, Error>) -> Void)
    func getUserRegistrationType(completion: @escaping (Result<String, Error>) -> Void)
    func getUserIsLoggedIn(completion: @escaping (Result<UsersDataEntity, Error>) -> Void)
    func twitterSignIn(completion: @escaping (Result<Void, Error>) -> Void)
}

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
                let authDataResult = try await Auth.auth().signIn(with: signInCredentials)
                print("User signed in with Google successfully: \(authDataResult.user.uid)")
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
                _ = try await signInWithAppleHelper.startSignWithAppleFlow()
                print("User signed in with Apple successfully")
                completion(.success(()))
            } catch {
                print("Apple sign in error: \(error.localizedDescription)")
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
//            check if its oauth provider
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
                _ = try await twitterSignInHelper.signInWithTwitter()
                print("User signed in with Twitter successfully")
                completion(.success(()))
            } catch {
                print("Twitter sign in error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
