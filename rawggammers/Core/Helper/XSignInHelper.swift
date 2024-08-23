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
    
    struct TwitterUserDetails {
        let id: String
        let email: String
        let fullName: String
        let photoURL: URL?
    }

    func signInWithTwitter() async throws -> TwitterUserDetails {
        let provider = OAuthProvider(providerID: "twitter.com")
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.getCredentialWith(nil) { credential, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let credential = credential {
                    Auth.auth().signIn(with: credential) { authResult, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            let user = authResult!.user
                            let id = user.uid
                            let email = user.email ?? ""
                            let fullName = user.displayName ?? ""
                            let photoURL = user.photoURL
                            
                            let userDetails = TwitterUserDetails(id: id, email: email, fullName: fullName, photoURL: photoURL)
                            continuation.resume(returning: userDetails)
                        }
                    }
                }
            }
        }
    }
}
