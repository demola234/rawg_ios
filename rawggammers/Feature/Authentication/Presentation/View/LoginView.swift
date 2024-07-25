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
                          
                          GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) { authViewModel.googleSignIn() }
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
                      .alert(isPresented: .constant(authViewModel.isLogged)) {
                          Alert(title: Text("Success"), message: Text("Success"), dismissButton: .default(Text("OK")))
                      }
                      .alert(isPresented: .constant(authViewModel.errorMessage != nil && authViewModel.errorMessage != "")) {
                          Alert(title: Text("Error"), message: Text(authViewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
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
}
