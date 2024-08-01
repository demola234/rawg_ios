//
//  ProfileView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.top, 16)
                
                Text("Ademola Kolawole")
                    .foregroundColor(Color.theme.accentTextColor)
                    .customFont(CustomFont.poppinsBold.copyWith(size: 24))
                
                //               Logout
                Button(action: {
                    authViewModel.logout()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.theme.accentTextColor)
                        
                        Text("Logout")
                            .foregroundColor(Color.theme.accentTextColor)
                            .customFont(CustomFont.poppinsRegualr.copyWith(size: 16))
                    }
                    .padding(12)
                    .background(Color.theme.accentTextColor)
                    .cornerRadius(8)
                }
                .padding(.top, 16)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
