//
//  ChangeUserAvatar.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 23/08/2024.
//
import SwiftUI

/// View for selecting and changing the user's avatar.
///
/// This view allows users to choose from a list of avatars grouped by game. Users can select an avatar, and the selected avatar can be applied to their account.
///
/// - Environment Objects:
///   - `settingsViewModel`: Manages user profile settings and updates.
/// - Binding:
///   - `showChangeAvatar`: Controls the visibility of this view.
/// - State:
///   - `selectedAvatar`: Tracks the currently selected avatar.
///   - `avatars`: List of available avatars fetched from `AvatarPreview`.
///   - `groupedAvatars`: Avatars grouped by their game name.
struct ChangeUserAvatar: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var showChangeAvatar: Bool
    // Fetch avatars from the AvatarPreview instance
    let avatars = AvatarPreview.instance.games
    
    // Group avatars by game name
    var groupedAvatars: [String: [GameAvatar]] {
        Dictionary(grouping: avatars, by: { $0.name })
    }
    
    @State private var selectedAvatar: GameAvatar?
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                
                Text("Choose Avatar")
                    .customFont(CustomFont.orbitronMedium.copyWith(size: 24))
                    .foregroundColor(.theme.primaryTextColor)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Spacer()
                
                // Iterate over each game group
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 40) {
                        ForEach(groupedAvatars.keys.sorted(), id: \.self) { gameName in
                            VStack(alignment: .leading) {
                                Text(gameName)
                                    .customFont(CustomFont.orbitronMedium.copyWith(size: 16))
                                    .foregroundColor(.theme.primaryTextColor)
                                    .padding(.leading, 16)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        
                                        ForEach(groupedAvatars[gameName] ?? [], id: \.id) { avatar in
                                            AvatarSelectionView(avatar: avatar, selectedAvatar: $selectedAvatar)
                                                .onTapGesture {
                                                    withAnimation {
                                                        // Check if the selected avatar is the same as the current avatar
                                                        if selectedAvatar == avatar {
                                                            selectedAvatar = nil
                                                        } else {
                                                            selectedAvatar = avatar
                                                        }
                                                    }
                                                }
                                                
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }

                if let selectedAvatar = selectedAvatar {
                    CustomButton(action: {
                        HepticManager().impact(style: .medium)
                        settingsViewModel.updateProfileImage(image: selectedAvatar.imageName)
                        showChangeAvatar = false
                        
                    }, title: "Select Avatar for Account", isEnable: true, backgroundColor: Color.theme.primaryTextColor)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: selectedAvatar)
                }
            }
        }
    }
}

/// View for displaying a single avatar option.
///
/// This view represents an individual avatar and highlights it when selected.
///
/// - Parameters:
///   - avatar: The avatar to display.
///   - selectedAvatar: The currently selected avatar, used to highlight the selected avatar.
struct AvatarSelectionView: View {
    let avatar: GameAvatar
    @Binding var selectedAvatar: GameAvatar?
    
    var body: some View {
        VStack {
            Image(avatar.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .scaleEffect(selectedAvatar == avatar ? 0.9 : 1)
                .padding(5)
                .overlay(
                    Circle()
                        .stroke(selectedAvatar == avatar ? Color.theme.primaryTextColor : Color.clear, lineWidth: 2)
                )
        }
    }
}

#Preview {
    ChangeUserAvatar(showChangeAvatar: .constant(true))
        .environmentObject(SettingsViewModel())
}
