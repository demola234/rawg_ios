//
//  HomeView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Text("Home View")
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
