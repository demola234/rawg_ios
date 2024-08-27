//
//  LogoutConfirmationView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 21/08/2024.
//

import SwiftUI

/// A view that displays a confirmation dialog for logging out.
///
/// This view presents a confirmation prompt with options to either cancel or proceed with logging out.
///
/// - Parameters:
///   - authViewModel: An `EnvironmentObject` responsible for handling authentication actions.
///   - showLogoutSheet: A `Binding` that controls the visibility of the logout confirmation sheet.
struct LogoutConfirmationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var showLogoutSheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Title of the confirmation dialog
            Text("Logout")
                .customFont(CustomFont.orbitronMedium.copyWith(size: 18))
                .foregroundColor(.theme.primaryTextColor)
            
            // Message asking for confirmation
            Text("Are you sure you want to log out?")
                .customFont(CustomFont.orbitronRegular.copyWith(size: 14))
                .foregroundColor(.theme.primaryTextColor)
            
            // Buttons for canceling or proceeding with logout
            HStack {
                Button("Cancel") {
                    withAnimation {
                        showLogoutSheet = false
                    }
                }
                .foregroundColor(.theme.primaryTextColor)
                
                Spacer()
                
                Button("Logout") {
                    authViewModel.logout()
                    showLogoutSheet = false
                }
                .foregroundColor(.theme.error)
            }
            .padding(.horizontal, 40)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    LogoutConfirmationView(showLogoutSheet: .constant(true))
}
