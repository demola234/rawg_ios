//
//  SignInWithAppleButton.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 25/07/2024.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct SignInWithAppleButtonRepresentable: UIViewRepresentable {
   
    
    let style: ASAuthorizationAppleIDButton.Style
    let type: ASAuthorizationAppleIDButton.ButtonType
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: type, style: style)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
}
