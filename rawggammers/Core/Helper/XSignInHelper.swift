//
//  XSignInHelper.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 28/07/2024.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

@MainActor
final class XSignInHelper {
    static let shared = XSignInHelper()
    
    init() {}
    
    func signInWithTwitter() async throws {
        let provider = OAuthProvider(providerID: "twitter.com")
        
        let credential: AuthCredential = try await withCheckedThrowingContinuation { continuation in
            provider.getCredentialWith(nil) { credential, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let credential = credential {
                    continuation.resume(returning: credential)
                }
            }
        }
        
        let result = try await Auth.auth().signIn(with: credential)
        let user = result.user
        
        // You can add any additional code to handle the signed-in user here
        print("Signed in user: \(user.uid)")
    }
}
