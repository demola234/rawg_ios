//
//  GameInfoView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 29/07/2024.
//

import SwiftUI

struct GameInfoView: View {
    var body: some View {
        VStack {
            InfoRowView(title: "Platforms", value: "XBox, PC")
            InfoRowView(title: "Genres", value: "Actions, Shooter, \nAdventure, RPG")
            InfoRowView(title: "Release Date", value: "NOV 11, 2024")
            InfoRowView(title: "Developers", value: "GSC Game World")
            InfoRowView(title: "Content Rating", value: "Rating Pending")
            InfoRowView(title: "Publishers", value: "GSC Game World")
            InfoRowView(title: "Website", value: "https://www.stalker2.com/")
        }
    }
}


#Preview {
    GameInfoView()
}
