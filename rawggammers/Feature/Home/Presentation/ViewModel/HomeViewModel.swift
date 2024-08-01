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
    @Published var selectedTab: Tab = .trending
    @Published var scrollTitle: String = "New and Trending Games"
    @Published var isPlatformsLoading: Bool
    @Published var errorMessage: String
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    private var ordering: String = "-relevance"
    
    
    private let repository: HomeRepository
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repository: HomeRepository = HomeRepositoryImpl.shared, errorMessage: String = "", games: [ResultData] = [], isGamesLoading: Bool = false, platforms: PlatformsEntity? = nil, isPlatformsLoading: Bool = false, movies: MoviesEntity? = nil, gameDetails: ResultData? = nil, bestGames: [ResultData] = [], selectedTab: Tab = .trending) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.games = games
        self.platforms = platforms
        self.isGamesLoading = isGamesLoading
        self.isPlatformsLoading = isPlatformsLoading
        self.movies = movies
        self.gameDetails = gameDetails
        self.bestGames = bestGames
        self.selectedTab = selectedTab
        getGames()
        getPlatForms()
        getBestGames()
       
    }
    
    func selectNewTab(tab: Tab) {
        self.selectedTab = tab
        self.currentPage = 1
        self.canLoadMore = true
        
        switch tab {
        case .trending:
            self.scrollTitle = "New and Trending Games"
            self.ordering = "-relevance"
            getGames()
        case .lastDays:
            self.scrollTitle = "Last 30 Days"
            getLastDays()
        case .thisWeek:
            self.scrollTitle = "This Week"
            self.ordering = "-released"
            getGames()
        case .nextWeek:
            self.scrollTitle = "Next Week"
            self.ordering = "released"
            getGames()
        }
    }
    
    
    func getLastDays() {
        isGamesLoading = true
        repository.getBestGames(year: 2024, discover: true, ordering: ordering, page: currentPage)
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
                    self?.games = games.results
                } else {
                    self?.games.append(contentsOf: games.results)
                }
                self?.isGamesLoading = false
                self?.canLoadMore = (games.results.count) > 0
            }
            .store(in: &cancellables)
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
                
                
                if self?.currentPage == 1 {
                    self?.bestGames = bestGames.results
                } else {
                    self?.bestGames.append(contentsOf: bestGames.results )
                }
                self?.isGamesLoading = false
                self?.canLoadMore = (bestGames.results.count ) > 0
            }
            .store(in: &cancellables)
    }
    
    func loadMoreGames() {
        guard canLoadMore else { return }
        currentPage += 1
        getBestGames()
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
                self?.games = games.results
            }
            .store(in: &cancellables)
    }
    
    
    func getGames() {
        isGamesLoading = true
        repository.getGames(discover: true, ordering: ordering, filter: true, page: currentPage)
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
                    self?.games = games.results
                } else {
                    self?.games.append(contentsOf: games.results )
                }
                self?.isGamesLoading = false
                self?.canLoadMore = (games.results.count ) > 0
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


