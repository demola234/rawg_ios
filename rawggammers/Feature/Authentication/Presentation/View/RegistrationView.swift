//
//  LoginView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct RegistrationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
   

    @FocusState private var emailFieldIsFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Let’s get started")
                        .customFont(CustomFont.orbitronBold.copyWith(size: 24))
                        .lineSpacing(30)
                        .foregroundColor(Color.theme.primaryTextColor)

                    Text("Create an Account to view the best gaming activities with RAWG.")
                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                        .lineLimit(2)
                        .foregroundColor(Color.theme.accentTextColor)
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 16) {
                        CustomTextFieldComponent(text: $authViewModel.email, placeholder: "Enter your email", imageName: "envelope", isSecure: false, label: "Email address")
                            .focused($emailFieldIsFocused)
                            .submitLabel(.next)
                            .onSubmit {
                                emailFieldIsFocused = false
                            }
                            .padding(.bottom, 10)

                        CustomTextFieldComponent(text: $authViewModel.password, placeholder: "Enter your password", imageName: "lock", isSecure: true, label: "Password")
                            .padding(.bottom, 10)
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
//                            Spacer()
                        
                        Text("Already have an account?")
                            .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                            .foregroundColor(Color.theme.accentTextColor)
                            .padding(.bottom, 10)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                                .foregroundColor(Color.theme.primaryTextColor)
                                .padding(.bottom, 10)
                            
                        }
                       
                    }

                    Spacer()

                    VStack(spacing: 16) {
                        CustomButton(action: {
                            // Implement create account action
                        }, title: "Create Account with Email", backgroundColor: Color.theme.primaryTextColor)

                        CustomButton(action: {
                            // Implement Google Sign-In action
                        }, title: "Continue with Google", imageName: "GoogleLogo", backgroundColor: Color.theme.primaryTextColor, borderColor: Color.theme.background)
                        
                        CustomButton(action: {
                            // Implement Google Sign-In action
                        }, title: "Continue with Apple", imageName: "AppleLogo", backgroundColor: Color.theme.primaryTextColor, borderColor: Color.theme.background)

                        
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)

                if authViewModel.isLoading {
                    ProgressView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onChange(of: authViewModel.isLogged) { isLogged in
                if isLogged {
                    alertTitle = "Success"
                    alertMessage = "Your account was successfully created."
                    showAlert = true
                }
            }
            .onChange(of: authViewModel.errorMessage) { errorMessage in
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    alertTitle = "Error"
                    alertMessage = errorMessage
                    showAlert = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    RegistrationView()
        .environmentObject(AuthenticationViewModel())
        .preferredColorScheme(.dark)
}
