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
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func logout() throws
    func resetPassword(email: String) async throws
    func updateEmail(email: String) async throws
    func updatePassword(password: String) async throws
    func googleSignIn() async throws
    func appleSignIn() async throws
}

struct AuthenticationRemoteDataSourceImpl: AuthenticationRemoteDataSource {
   
    
    func googleSignIn() async throws {
        do {
            let signInCredentials = try await signInGoogle()
            let authDataResult = try await Auth.auth().signIn(with: signInCredentials)
            print("User signed in with Google successfully: \(authDataResult.user.uid)")
        } catch {
            print("Google sign in error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signInGoogle() async throws -> AuthCredential {
        // Ensure topViewController is accessed on the main thread
        guard let topVC = await Utilities.shared.topViewController() else { throw URLError(.cannotFindHost) }
        
        // Ensure GIDSignIn is called on the main thread
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
    
    func appleSignIn() async throws {
        let signInWithAppleHelper = await AppleSignInHelper()
        do {
          let signUp =  try await signInWithAppleHelper.startSignWithAppleFlow()
            print("User signed in with Apple successfully")
        } catch {
            print("Apple sign in error: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    static let shared = AuthenticationRemoteDataSourceImpl()
    
    private init() {}
    
    func login(email: String, password: String) async throws {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            print("User logged in successfully: \(authDataResult.user.uid)")
        } catch {
            print("Login error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func register(email: String, password: String) async throws {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("User registered successfully: \(authDataResult.user.uid)")
        } catch {
            print("Registration error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func logout() throws {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully")
        } catch {
            print("Logout error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Password reset email sent successfully")
        } catch {
            print("Password reset error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        do {
            try await user.sendEmailVerification()
            print("Email updated successfully")
        } catch {
            print("Update email error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }
        
        do {
            try await user.updatePassword(to: password)
            print("Password updated successfully")
        } catch {
            print("Update password error: \(error.localizedDescription)")
            throw error
        }
    }
}
