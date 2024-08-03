//
//  RegistrationView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import SwiftUI

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
                
                if authViewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Let’s get started")
                                .customFont(CustomFont.orbitronBold.copyWith(size: 24))
                                .lineSpacing(30)
                                .foregroundColor(Color.theme.primaryTextColor)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 24)
                            
                            Text("Create an Account to view the best gaming activities with RAWG.")
                                .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                                .lineLimit(2)
                                .foregroundColor(Color.theme.accentTextColor)
                                .padding(.bottom, 24)
                                .padding(.horizontal, 24)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                CustomTextFieldComponent(
                                    text: $authViewModel.email,
                                    placeholder: "sample@gmail.com",
                                    imageName: "envelope",
                                    isSecure: false,
                                    label: "Email address",
                                    keyboardType: .emailAddress,
                                    border: true
                                )
                                .submitLabel(.next)
                                .padding(.bottom, 1)
                                
                                if !authViewModel.isValidEmail && !authViewModel.email.isEmpty {
                                    Text("Please enter a valid email address.")
                                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                                        .foregroundColor(Color.theme.error)
                                        .padding(.bottom, 10)
                                }
                                
                                CustomTextFieldComponent(
                                    text: $authViewModel.password,
                                    placeholder: "Create a unique password",
                                    imageName: "lock",
                                    isSecure: true,
                                    label: "Password",
                                    border: true
                                )
                                .submitLabel(.done)
                                .padding(.bottom, 1)
                                
                                if authViewModel.isValidPassword != "" && !authViewModel.password.isEmpty {
                                    Text(authViewModel.isValidPassword)
                                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                                        .foregroundColor(Color.theme.error)
                                        .padding(.bottom, 10)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            
                            Spacer()
                            
                          
                                NavigationLink {
                                    LoginView()
                                } label: {
                                    HStack (alignment: .center) {
                                        Text("Already have a Rawg Account?")
                                            .customFont(CustomFont.orbitronMedium.copyWith(size: 16))
                                        
                                            .foregroundColor(.theme.primaryTextColor)
                                        Text("Sign in")
                                            .customFont(CustomFont.orbitronBold.copyWith(size: 16))
                                            .foregroundColor(.theme.goldColor)
                                        
                                    
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                            
                            
                            
                            HStack {
                                AuthButton(action: {
                                    authViewModel.googleSignIn()
                                }, imageName: "GoogleLogo")
                                
                                Spacer()
                                
                                AuthButton(action: {
                                    authViewModel.twitterSignIn()
                                }, imageName: "TwitterLogo")
                                
                                
                                Spacer()
                                
                                AuthButton(action: {
                                    authViewModel.appleSignIn()
                                }, imageName: "AppleLogo")
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                            
                            CustomButton(action: {
                                HepticManager().impact(style: .medium)
                                authViewModel.login()
                            }, title: "Create Account with Email", isEnable: !authViewModel.email.isEmpty && !authViewModel.password.isEmpty, backgroundColor: Color.theme.primaryTextColor)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 24)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .onReceive(authViewModel.$isLogged) { isLogged in
                        if isLogged {
                            alertTitle = "Success"
                            alertMessage = "You have successfully created an account"
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
    RegistrationView()
        .environmentObject(AuthenticationViewModel())
}
