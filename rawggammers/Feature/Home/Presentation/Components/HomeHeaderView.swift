//
//  HomeHeaderView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 30/07/2024.
//

import SwiftUI

struct HomeHeaderView: View {
    var userDetails = UsersDataEntity()
    var body: some View {
        HStack {
            if let imageUrl = URL(string: userDetails.profileImageURL) {
                NetworkImageView(imageURL: imageUrl)
                    .frame(width: 38, height: 38)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .padding(.trailing, 7)
            } else {
                Image("Games")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 38, height: 38)
                    .clipShape(Circle())
                    .padding(.trailing, 7)
            }
            
            VStack(alignment: .leading) {
                Text("Welcome \(userDetails.username)")
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 16))
                    .foregroundColor(Color.theme.primaryTextColor)
                    .padding(.bottom, 2)
                Text("What event would you like to watch today?")
                    .customFont(CustomFont.poppinsRegualr.copyWith(size: 12))
                    .foregroundColor(Color.theme.accentTextColor)
                 
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    HomeHeaderView()
}
