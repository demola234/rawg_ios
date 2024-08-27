//
//  AvatarSettingsView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 20/08/2024.
//

import SwiftUI

/// A view displaying the user's avatar and options to change or update it.
///
/// This view shows the user's current avatar, a placeholder image if none is set, or a progress view if the avatar is being updated. It includes a title and description about changing the avatar, as well as a navigation arrow icon.
struct AvatarSettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            // Display the user's avatar or a placeholder if none is set
            if (settingsViewModel.user?.photoUrl.isEmpty ?? true) {
                Image("Spiderman1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 49, height: 49)
                    .clipped()
            } else if(settingsViewModel.isUpdating) {
                ProgressView()
                    .frame(width: 49, height: 49)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.all, 1)
            } else {
                NetworkImageView(imageURL: URL(string: settingsViewModel.user?.photoUrl ?? "")!)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 49, height: 49)
                    .clipped()
            }
            
            // Description of avatar settings
            VStack(alignment: .leading, spacing: 5) {
                Text("Change Avatar")
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 18))
                    .foregroundColor(.theme.primaryTextColor)
                
                Text("Update or choose a new avatar")
                    .customFont(CustomFont.poppinsRegualr.copyWith(size: 14))
                    .foregroundColor(.theme.primaryTextColor)
            }
            
            Spacer()
            
            // Navigation arrow icon
            Image("left_arrow")
                .resizable()
                .foregroundColor(.theme.primaryTextColor)
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .clipped()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(Color.theme.cardColor)
        .cornerRadius(20)
    }
}

#Preview {
    AvatarSettingsView()
        .environmentObject(SettingsViewModel())
}
