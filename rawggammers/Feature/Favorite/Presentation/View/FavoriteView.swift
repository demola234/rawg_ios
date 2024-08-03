//
//  FavoriteScreen.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//
import SwiftUI

struct FavoriteScreen: View {
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @State private var showDetailsView = false
    @State private var selectedDetails: ResultData?
    @State private var showAlert = false // Add this state variable

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Favorite Games")
                    .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                    .foregroundColor(.theme.primaryTextColor)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                Spacer()
                ScrollView {
                    ForEach(favoriteViewModel.favorites, id: \.id) { item in
                        FavoriteCardView(favorite: item)
                            .padding(.horizontal, 24)
                            .onTapGesture {
                                segue(favoriteDetails: item)
                            }
                            .onLongPressGesture {
                                favoriteViewModel.selectedFavorites = item
                                showAlert = true
                            }
                    }
                }
            }
            .navigationDestination(isPresented: $showDetailsView) {
                if let details = selectedDetails {
                    GameDetailsView(gameDetails: $selectedDetails)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Favorite"),
                    message: Text("Are you sure you want to delete \(favoriteViewModel.selectedFavorites?.name ?? "this favorite")?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let favorite = favoriteViewModel.selectedFavorites {
                            favoriteViewModel.deleteFavorite(favorite: favorite)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func segue(favoriteDetails: FavoriteEntity) {
        selectedDetails = ResultData(
            id: 0,
            slug: favoriteDetails.slug,
            name: favoriteDetails.name,
            released: favoriteDetails.released,
            description: nil,
            backgroundImage: favoriteDetails.backgroundImage,
            rating: favoriteDetails.rating,
            ratingTop: nil,
            ratings: nil,
            ratingsCount: nil,
            reviewsTextCount: nil,
            added: nil,
            parentsCount: nil,
            playtime: nil,
            suggestionsCount: favoriteDetails.suggestionsCount,
            updated: favoriteDetails.updated,
            reviewsCount: favoriteDetails.reviewsCount,
            website: nil,
            platforms: nil,
            genres: nil,
            stores: nil,
            developers: nil,
            tags: nil,
            shortScreenshots: nil,
            communityRating: nil
        )
        showDetailsView.toggle()
    }
}

#Preview {
    FavoriteScreen()
        .environmentObject(FavoriteViewModel())
}
