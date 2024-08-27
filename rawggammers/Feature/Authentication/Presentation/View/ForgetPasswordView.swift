//
//  ForgetPasswordView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 01/08/2024.
//

import SwiftUI

/// A view that allows users to reset their password by entering their email address.
/// It provides feedback through alerts and dismisses itself upon successful password reset request.
struct ForgetPasswordView: View {
    /// The presentation mode of the current view, allowing it to be dismissed.
    @Environment(\.presentationMode) var presentationMode
    
    /// The email address entered by the user.
    @State private var email: String = ""
    
    /// A boolean value indicating whether to show an alert.
    @State private var showAlert = false
    
    /// The message to be displayed in the alert.
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            NavigationView {
                VStack(spacing: 20) {
                    Text("Forget Password")
                        .customFont(CustomFont.orbitronBold.copyWith(size: 24))
                        .padding(.top, 40)
                    
                    Text("Enter your email address to reset your password.")
                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                        .foregroundColor(Color.theme.accentTextColor)
                    
                    CustomTextFieldComponent(
                        text: $email,
                        placeholder: "sample@gmail.com",
                        imageName: "envelope",
                        isSecure: false,
                        label: "Email address",
                        keyboardType: .emailAddress,
                        border: true
                    )
                    .submitLabel(.done)
                    .padding(.bottom, 1)
                    
                    CustomButton(action: {
                        HepticManager().impact(style: .medium)
                        if isValidEmail(email) {
                            // Trigger forget password action
                            alertMessage = "Password reset instructions have been sent to \(email)."
                        } else {
                            alertMessage = "Please enter a valid email address."
                        }
                        showAlert = true
                    }, title: "Reset Password", isEnable: !email.isEmpty, backgroundColor: Color.theme.primaryTextColor)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Forget Password"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                        if isValidEmail(email) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
            }
        }
    }
    
    /// Validates the given email address using a regular expression.
    /// - Parameter email: The email address to be validated.
    /// - Returns: A Boolean value indicating whether the email address is valid.
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    ForgetPasswordView()
}
