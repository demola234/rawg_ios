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
        var provider = OAuthProvider(providerID: "twitter.com")
        
            provider.getCredentialWith(nil) { credential, error in
                if let error = error {
                } else if let credential = credential {
                Auth.auth().signIn(with: credential)
                   
                    print("Twitter OAuth credential: \(credential)")
                    
                }
            }
        }
}
