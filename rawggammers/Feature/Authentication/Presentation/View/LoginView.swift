//
//  LoginView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""

    var body: some View {
        NavigationView {
            ZStack {
                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        TextField("Email", text: $authViewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        SecureField("Password", text: $authViewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            authViewModel.register()
                        }) {
                            Text("Login")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                            authViewModel.googleSignIn()
                        }
                        .frame(height: 50)
                        .padding()
                        
                        // Apple SignIn Button
                        Button(action: {
                            authViewModel.appleSignIn()
                        }, label: {
                            SignInWithAppleButtonRepresentable(style: .black, type: .continue)
                                .allowsHitTesting(false)
                                .frame(height: 50)
                                .padding()
                        })
                        
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .onChange(of: authViewModel.isLogged) {
                        if authViewModel.isLogged {
                            alertTitle = "Success"
                            alertMessage = "You have successfully logged in."
                            showAlert = true
                        }
                    }
                    .onChange(of: authViewModel.errorMessage) {
                        if let errorMessage = authViewModel.errorMessage, !errorMessage.isEmpty {
                            alertTitle = "Error"
                            alertMessage = errorMessage
                            showAlert = true
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .padding()
                    .navigationTitle("Registration")
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
