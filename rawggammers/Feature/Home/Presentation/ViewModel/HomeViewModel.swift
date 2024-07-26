//
//  HomeViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var games: [GamesEntity] = []
    @Published var isGamesLoading: Bool = false
    @Published var errorMessage: String
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    
    
    private let repository: HomeRepository
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repository: HomeRepository = HomeRepositoryImpl.shared, errorMessage: String = "", games: [GamesEntity] = [], isGamesLoading: Bool = false) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.games = games
        self.isGamesLoading = isGamesLoading
        getGames()
    }
    
    func getGames() {
        isGamesLoading = true
        repository.getGames(discover: true, ordering: "-relevance", filter: true, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        self.errorMessage = error.localizedDescription
                        self.isGamesLoading = false
                
                }
            } receiveValue: { [weak self] games in
                self?.games = games
            }
            .store(in: &cancellables)

    }
    
}


