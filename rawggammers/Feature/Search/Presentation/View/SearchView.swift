//
//  SearchView.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()

       var body: some View {
           NavigationView {
               VStack {
                   TextField("Search games...", text: $viewModel.searchText, onCommit: {
                       viewModel.searchGames()
                   })
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding()
                    Spacer()
                   if viewModel.isSearchLoading {
                       ProgressView("Loading...")
                           .padding()
                   } else if !viewModel.errorMessage.isEmpty {
                       Text("Error: \(viewModel.errorMessage)")
                           .foregroundColor(.red)
                           .padding()
                   } else {
                       List {
                           if let searchData = viewModel.searchData {
                               ForEach(searchData.results ?? [], id: \.id) { game in
                                   Text(game.name ?? "")
                               }
                           }
                       }
                   }
               }
               .navigationTitle("Game Search")
           }
       }
   }

   struct SearchView_Previews: PreviewProvider {
       static var previews: some View {
           SearchView()
       }
   }
