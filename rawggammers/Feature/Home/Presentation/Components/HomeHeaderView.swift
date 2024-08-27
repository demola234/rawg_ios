//
//  HomeHeaderView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 30/07/2024.
//

import SwiftUI

/// A view that displays the header section of the home screen, including user details, a profile picture, and greeting messages.
///
/// The `HomeHeaderView` presents a header with a profile picture and a welcome message. It includes functionality to display a loading indicator if the profile picture is being updated and allows users to change their avatar or username.
struct HomeHeaderView: View {
    /// The user details to display in the header. Initialized with an empty `UsersDataEntity`.
    var userDetails = UsersDataEntity()
    
    /// The view model responsible for managing user settings and state.
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    /// State variable to control the presentation of the username creation sheet.
    @State private var showName: Bool = false
    
    /// State variable to control the presentation of the avatar change sheet.
    @State private var showChangeAvatar: Bool = false

    var body: some View {
        HStack {
            // Display profile picture or loading indicator
            if (settingsViewModel.user?.photoUrl.isEmpty ?? true) {
                Image("Spiderman1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 38, height: 38)
                    .clipShape(Circle())
                    .padding(.trailing, 7)
            } else if(settingsViewModel.isUpdating) {
                ProgressView()
                    .frame(width: 38, height: 38)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.all, 1)
            } else {
                NetworkImageView(imageURL: URL(string: settingsViewModel.user?.photoUrl ?? "")!)
                    .frame(width: 38, height: 38)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.trailing, 7)
                    .onTapGesture {
                        showChangeAvatar.toggle()
                    }
            }
            
            VStack(alignment: .leading) {
                Text("Welcome \(settingsViewModel.user?.name ?? "User")!")
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 16))
                    .foregroundColor(Color.theme.primaryTextColor)
                    .padding(.bottom, 2)
                Text("What games are you looking at today?")
                    .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                    .foregroundColor(Color.theme.accentTextColor)
            }
            .onTapGesture {
                showName.toggle()
            }
            Spacer()
        }
        .sheet(isPresented: $showName, content: {
            CreateUsernameView()
                .environmentObject(settingsViewModel)
        })
        .sheet(isPresented: $showChangeAvatar) {
            ChangeUserAvatar(showChangeAvatar: $showChangeAvatar)
                .environmentObject(settingsViewModel)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    HomeHeaderView()
}
