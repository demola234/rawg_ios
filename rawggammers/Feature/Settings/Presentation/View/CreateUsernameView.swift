//
//  CreateUsernameView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 24/08/2024.
//

import SwiftUI

struct CreateUsernameView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var username: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            NavigationView {
                VStack(spacing: 20) {
                    Text("Change Username")
                        .customFont(CustomFont.orbitronBold.copyWith(size: 24))
                        .padding(.top, 40)
                    
                    Text("Enter the name you want to use on your profile")
                        .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                        .foregroundColor(Color.theme.accentTextColor)
                    
                    CustomTextFieldComponent(
                        text: $username,
                        placeholder: settingsViewModel.user?.name ?? "username",
                        imageName: "person.fill",
                        isSecure: false,
                        label: "Username",
                        keyboardType: .default,
                        border: true
                        
                        
                    )
                    .submitLabel(.done)
                    .padding(.bottom, 1)
                    
                    CustomButton(action: {
                        HepticManager().impact(style: .medium)
                        settingsViewModel.updateProfileName(name: username)
                        showAlert = true
                    }, title: "Update Username", isEnable: !username.isEmpty, backgroundColor: Color.theme.primaryTextColor)
                    .padding(.horizontal, 24)
                    
                   
                    Spacer()
                }
                .padding(.horizontal, 24)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Username"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
        }
    }
}

#Preview {
    CreateUsernameView()
}
