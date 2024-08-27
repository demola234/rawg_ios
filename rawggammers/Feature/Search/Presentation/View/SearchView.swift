//
//  SearchView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

/// The main view for searching games and displaying search results or previously saved searches.
///
/// This view provides a search interface, displays search results, shows saved searches, and handles navigation and deletion of saved searches.
struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @State private var selectedDetails: ResultData? = nil
    @State private var showDetailsView = false
    @State private var showDeleteConfirmation = false
    @State private var searchToDeleteIndex: Int? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack {
                    // TextField for search
                    SearchTextFieldComponent(
                        text: $viewModel.searchText,
                        placeholder: "Search For New Games on RAWG",
                        label: "",
                        keyboardType: .webSearch,
                        onCommit: {
                            viewModel.searchGames()
                            viewModel.saveSearch(name: viewModel.searchText)
                        }
                    )
                    .onChange(of: viewModel.searchText) { newValue in
                        if newValue.isEmpty {
                            viewModel.getAllSavedSearches()
                        }
                    }

                    // Error message
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    // Loading indicator
                    if viewModel.isSearchLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        // List of search results or saved searches
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 20) {
                                if viewModel.searchText.isEmpty {
                                    if viewModel.namedSearches?.isEmpty ?? true {
                                        Spacer()
                                        Text("No saved searches")
                                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                                            .foregroundColor(.theme.primaryTextColor)
                                            .padding()
                                    } else {
                                        Text("Previous Searches")
                                            .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                                            .foregroundColor(.theme.primaryTextColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                        ForEach(Array(viewModel.namedSearches?.enumerated() ?? [].enumerated()), id: \.element.id) { index, namedSearches in
                                            Button(action: {
                                                viewModel.searchText = namedSearches.name ?? ""
                                                viewModel.searchGames()
                                            }) {
                                                ZStack(alignment: .leading) {
                                                    Text(namedSearches.name ?? "")
                                                        .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                                                        .foregroundColor(.theme.primaryTextColor)
                                                        .lineLimit(2)
                                                        .multilineTextAlignment(.leading)
                                                        .padding(.horizontal, 30)
                                                        .frame(width: 396, height: 74, alignment: .leading)
                                                }
                                                .frame(width: 396, height: 74)
                                                .background(Color.theme.accentTextColor)
                                                .cornerRadius(15)
                                                .contextMenu {
                                                    Button(action: {
                                                        searchToDeleteIndex = index
                                                        showDeleteConfirmation = true
                                                    }) {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else if viewModel.searchData?.isEmpty ?? true && viewModel.searchText != "" {
                                    Spacer()
                                    Text("No results found")
                                        .customFont(CustomFont.orbitronSemiBold.copyWith(size: 20))
                                        .foregroundColor(.theme.primaryTextColor)
                                        .padding()
                                } else {
                                    ForEach(viewModel.searchData ?? [], id: \.id) { searchResult in
                                        SearchCardComponent(searchResult: searchResult)
                                            .onTapGesture {
                                                segue(gameDetails: searchResult)
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    Spacer()
                }
                .navigationDestination(isPresented: $showDetailsView) {
                    if selectedDetails != nil {
                        GameDetailsView(gameDetails: $selectedDetails)
                    }
                }
                .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete this saved search?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let index = searchToDeleteIndex {
                                viewModel.deleteSearch(searchData: viewModel.namedSearches?[index] ?? SearchDataEntity())
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .onAppear {
                if viewModel.searchText.isEmpty {
                    viewModel.getAllSavedSearches()
                }
            }
        }
    }

    /// Triggers a segue to show the details view for a selected game.
    ///
    /// - Parameter gameDetails: The `ResultData` object representing the game for which details are to be shown.
    private func segue(gameDetails: ResultData) {
        selectedDetails = gameDetails
        showDetailsView.toggle()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
