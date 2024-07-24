//
//  LoginView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/07/2024.
//

import SwiftUI
import GoogleSignInSwift

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
                          
                          if let errorMessage = authViewModel.errorMessage {
                              Text(errorMessage)
                                  .foregroundColor(.red)
                                  .padding()
                          }
                      }
                      .alert(isPresented: .constant(authViewModel.errorMessage != nil)) {
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
