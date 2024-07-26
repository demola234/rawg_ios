//
//  HomeViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var games: [ResultData] = []
    @Published var bestGames: [ResultData] = []
    @Published var platforms: PlatformsEntity?
    @Published var movies: MoviesEntity?
    @Published var gameDetails: ResultData?
    @Published var isGamesLoading: Bool = false
    @Published var isPlatformsLoading: Bool
    @Published var errorMessage: String
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    
    
    private let repository: HomeRepository
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repository: HomeRepository = HomeRepositoryImpl.shared, errorMessage: String = "", games: [ResultData] = [], isGamesLoading: Bool = false, platforms: PlatformsEntity? = nil, isPlatformsLoading: Bool = false, movies: MoviesEntity? = nil, gameDetails: ResultData? = nil, bestGames: [ResultData] = []) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.games = games
        self.platforms = platforms
        self.isGamesLoading = isGamesLoading
        self.isPlatformsLoading = isPlatformsLoading
        self.movies = movies
        self.gameDetails = gameDetails
        self.bestGames = bestGames
        //        getPlatForms()
        //        getBestGames()
        getGames()
    }
    
    func getBestGames() {
        isGamesLoading = true
        repository.getBestGames(year: 2023, discover: true, ordering: "-added", page: currentPage)
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
            } receiveValue: { [weak self] bestGames in
                self?.bestGames = bestGames.results ?? []
            }
            .store(in: &cancellables)
    }
    
    func loadMoreGames() {
        guard canLoadMore else { return }
        currentPage += 1
        getGames()
    }
    
    
    func getGameDetails(game: String) {
        repository.getGameDetails(game: game)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] gameDetails in
                self?.gameDetails = gameDetails
            }
            .store(in: &cancellables)
    }
    
    
    func getMovies(game: String) {
        repository.getMovies(game: game)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
    
    
    func getGamesByPlatform(platform: Int) {
        repository.getGamesByPlatform(platform: platform, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] games in
                self?.games = games.results ?? []
            }
            .store(in: &cancellables)
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
                if self?.currentPage == 1 {
                    self?.games = games.results ?? []
                } else {
                    self?.games.append(contentsOf: games.results ?? [])
                }
                self?.isGamesLoading = false
                self?.canLoadMore = (games.results?.count ?? 0) > 0
            }
            .store(in: &cancellables)
    }
    
    func getPlatForms() {
        isPlatformsLoading = true
        repository.getPlatForms()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.isPlatformsLoading = false
                }
            } receiveValue: { [weak self] platforms in
                self?.platforms = platforms
            }
            .store(in: &cancellables)
    }
    
}


