//
//  LogoutConfirmationView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 21/08/2024.
//

import SwiftUI

struct LogoutConfirmationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var showLogoutSheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Logout")
                .customFont(CustomFont.orbitronMedium.copyWith(size: 18))
                .foregroundColor(.theme.primaryTextColor)
            
            Text("Are you sure you want to log out?")
                .customFont(CustomFont.orbitronRegular.copyWith(size: 14))
                .foregroundColor(.theme.primaryTextColor)
            
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
