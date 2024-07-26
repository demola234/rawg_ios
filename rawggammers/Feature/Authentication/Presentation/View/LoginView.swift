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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sign in to RAWG")
                                .customFont(CustomFont.orbitronBold.copyWith(size: 32))
                                .lineSpacing(30)
                                .foregroundColor(Color.theme.primaryTextColor)
                            
                            Text("Enter your account details to continue experiencing the best games content.")
                                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                                .lineLimit(2)
                                .foregroundColor(Color.theme.accentTextColor)
                                .padding(.bottom, 10)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                CustomTextFieldComponent(text: $authViewModel.email, placeholder: "Enter your email", imageName: "envelope", isSecure: false, label: "Email address", keyboardType: .emailAddress)
                                    .submitLabel(.next)
                                    .padding(.bottom, 1)
                                
                                if !authViewModel.isValidEmail {
                                    Text("Please enter a valid email address.")
                                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                                        .foregroundColor(Color.theme.error)
                                        .padding(.bottom, 10)
                                }
                                
                                CustomTextFieldComponent(text: $authViewModel.password, placeholder: "Enter your password", imageName: "lock", isSecure: true, label: "Password")
                                    .submitLabel(.done)
                                    .padding(.bottom, 1)
                                
                                if !authViewModel.isValidPassword {
                                    Text("Password must be at least 8 characters, contain at least one number and one special character.")
                                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                                        .foregroundColor(Color.theme.error)
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding(.vertical, 20)
                            
                            HStack {
                                Text("Don't have an account?")
                                    .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                                    .foregroundColor(Color.theme.accentTextColor)
                                    .padding(.bottom, 10)
                                
                                NavigationLink(destination: RegistrationView()) {
                                    Text("Create Account")
                                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                                        .foregroundColor(Color.theme.primaryTextColor)
                                        .padding(.bottom, 10)
                                }
                                .navigationBarBackButtonHidden(true)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 16) {
                                CustomButton(action: {
                                    authViewModel.login()
                                }, title: "Login", isEnable: !authViewModel.email.isEmpty && !authViewModel.password.isEmpty, backgroundColor: Color.theme.primaryTextColor)
                                
                                CustomButton(action: {
                                    authViewModel.googleSignIn()
                                }, title: "Continue with Google", imageName: "GoogleLogo", backgroundColor: Color.theme.background, borderColor: Color.theme.primaryTextColor, textColor: .theme.primaryTextColor)
                                
                                CustomButton(action: {
                                    authViewModel.appleSignIn()
                                }, title: "Continue with Apple", imageName: "AppleLogo", backgroundColor: Color.theme.primaryTextColor, borderColor: Color.theme.background)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .onReceive(authViewModel.$isLogged) { isLogged in
                        if isLogged {
                            alertTitle = "Success"
                            alertMessage = "You have successfully logged in."
                            showAlert = true
                        }
                    }
                    .onReceive(authViewModel.$errorMessage) { errorMessage in
                        if let errorMessage = errorMessage, !errorMessage.isEmpty {
                            alertTitle = "Error"
                            alertMessage = errorMessage
                            showAlert = true
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
        .preferredColorScheme(.dark)
}
