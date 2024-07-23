//
//  Authentication_Remote_DS.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import Foundation
import Firebase
import FirebaseAuth

import Foundation
import Firebase
import FirebaseAuth

protocol AuthenticationRemoteDataSource {
    func login(email: String, password: String)  async throws
    func register(email: String, password: String)  async throws
    func logout() throws
    func resetPassword(email: String)  async throws
    func updateEmail(email: String)  async throws
    func updatePassword(password: String)  async throws
}

struct AuthenticationRemoteDataSourceImpl: AuthenticationRemoteDataSource {
    
    static let shared = AuthenticationRemoteDataSourceImpl()
    
    private init() {}
    
    func login(email: String, password: String) async throws {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            print("User logged in successfully: \(authDataResult.user.uid)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func register(email: String, password: String) async throws {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("User registered successfully: \(authDataResult.user.uid)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func logout() throws {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func resetPassword(email: String)  async throws {
        
       do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Password reset email sent successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func updateEmail(email: String)  async throws {
        do {
            try await Auth.auth().currentUser?.sendEmailVerification()
            print("Email updated successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
       
    }
    
    func updatePassword(password: String)  async throws {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: password)
            print("Password updated successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
       
    }
}
