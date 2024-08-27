//
//  HomeViewModel.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

/// A view model for managing and providing game-related data to the `HomeView`.
/// Conforms to `ObservableObject` to support SwiftUI's data binding.
class HomeViewModel: ObservableObject {
    
    /// A published array of games.
    @Published var games: [ResultData] = []
    
    /// A published array of platform-specific games.
    @Published var platformGames: [ResultData] = []
    
    /// A published array of the best games.
    @Published var bestGames: [ResultData] = []
    
    /// A published optional entity representing platforms.
    @Published var platforms: PlatformsEntity?
    
    /// A published optional entity representing movies related to games.
    @Published var movies: MoviesEntity?
    
    /// A published optional entity representing details of a specific game.
    @Published var gameDetails: ResultData?
    
    /// A published optional array of game series.
    @Published var gameSeries: [ResultData]?
    
    /// A published Boolean value indicating if games are currently loading.
    @Published var isGamesLoading: Bool = false
    
    /// A published Boolean value indicating if game details are currently loading.
    @Published var isDetailsLoading: Bool = false
    
    /// A published tab value indicating the currently selected tab.
    @Published var selectedTab: Tab = .trending
    
    /// A published string representing the title for scrolling.
    @Published var scrollTitle: String = "New and Trending Games"
    
    /// A published Boolean value indicating if platforms are currently loading.
    @Published var isPlatformsLoading: Bool
    
    /// A published string containing the error message if any errors occur.
    @Published var errorMessage: String
    
    /// A published optional entity representing screenshots of a game.
    @Published var screenShots: GameScreenShotsEntity?
    
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true
    private var ordering: String = "-relevance"
    
    private let repository: HomeRepository
    private var cancellables = Set<AnyCancellable>()
    
    /// Initializes a new `HomeViewModel` instance.
    /// - Parameters:
    ///   - repository: An instance conforming to `HomeRepository` for data fetching. Defaults to `HomeRepositoryImpl.shared`.
    ///   - errorMessage: An initial error message string. Defaults to an empty string.
    ///   - games: An initial array of `ResultData` for games. Defaults to an empty array.
    ///   - platformGames: An initial array of `ResultData` for platform-specific games. Defaults to an empty array.
    ///   - isGamesLoading: An initial Boolean value indicating if games are loading. Defaults to `false`.
    ///   - platforms: An initial optional `PlatformsEntity`. Defaults to `nil`.
    ///   - isPlatformsLoading: An initial Boolean value indicating if platforms are loading. Defaults to `false`.
    ///   - movies: An initial optional `MoviesEntity`. Defaults to `nil`.
    ///   - gameDetails: An initial optional `ResultData` for game details. Defaults to `nil`.
    ///   - bestGames: An initial array of `ResultData` for the best games. Defaults to an empty array.
    ///   - selectedTab: An initial `Tab` value for the selected tab. Defaults to `.trending`.
    ///   - isDetailsLoading: An initial Boolean value indicating if game details are loading. Defaults to `false`.
    init(repository: HomeRepository = HomeRepositoryImpl.shared, errorMessage: String = "", games: [ResultData] = [], platformGames: [ResultData] = [], isGamesLoading: Bool = false, platforms: PlatformsEntity? = nil, isPlatformsLoading: Bool = false, movies: MoviesEntity? = nil, gameDetails: ResultData? = nil, bestGames: [ResultData] = [], selectedTab: Tab = .trending, isDetailsLoading: Bool = false) {
        self.repository = repository
        self.errorMessage = errorMessage
        self.games = games
        self.platformGames = platformGames
        self.platforms = platforms
        self.isGamesLoading = isGamesLoading
        self.isPlatformsLoading = isPlatformsLoading
        self.movies = movies
        self.gameDetails = gameDetails
        self.bestGames = bestGames
        self.selectedTab = selectedTab
        self.isDetailsLoading = isDetailsLoading
        
        if games.isEmpty {
            getGames()
        }
        if platforms?.results?.isEmpty ?? true {
            getPlatForms()
        }
        if bestGames.isEmpty {
            getBestGames()
        }
    }
    
    /// Selects a new tab and updates the games list based on the selected tab.
    /// - Parameter tab: The new tab to select.
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
    
    /// Fetches games for the last 30 days and updates the `games` property.
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
    
    /// Fetches the best games of the current year and updates the `bestGames` property.
    func getBestGames() {
        repository.getBestGames(year: 2023, discover: true, ordering: "-added", page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] bestGames in
                if self?.currentPage == 1 {
                    self?.bestGames = bestGames.results
                } else {
                    self?.bestGames.append(contentsOf: bestGames.results )
                }
                self?.canLoadMore = (bestGames.results.count ) > 0
            }
            .store(in: &cancellables)
    }
    
    /// Loads more games if more games are available.
    func loadMoreGames() {
        guard canLoadMore else { return }
        currentPage += 1
        getBestGames()
    }
    
    /// Fetches detailed information about a specific game.
    /// - Parameter game: The identifier of the game to fetch details for.
    func getGameDetails(game: String) {
        self.isDetailsLoading = true
        repository.getGameDetails(game: game)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.isDetailsLoading = false
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] gameDetails in
                self?.gameDetails = gameDetails
                self?.isDetailsLoading = false
            }
            .store(in: &cancellables)
    }
    
    /// Fetches movies related to a specific game.
    /// - Parameter game: The identifier of the game to fetch movies for.
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
    
    /// Fetches games available on a specific platform.
    /// - Parameter platform: The identifier of the platform to fetch games for.
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
                self?.platformGames = games.results
            }
            .store(in: &cancellables)
    }
    
    /// Fetches games based on the current tab's settings.
    func getGames() {
        repository.getGames(discover: true, ordering: ordering, filter: true, page: currentPage)
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
                if self?.currentPage == 1 {
                    self?.games = games.results
                } else {
                    self?.games.append(contentsOf: games.results )
                }
                self?.canLoadMore = (games.results.count ) > 0
            }
            .store(in: &cancellables)
    }
    
    /// Fetches platform information.
    func getPlatForms() {
        repository.getPlatForms()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] platforms in
                self?.platforms = platforms
            }
            .store(in: &cancellables)
    }
    
    /// Fetches screenshots for a specific game.
    /// - Parameter game: The identifier of the game to fetch screenshots for.
    func getScreenshots(game: String) {
        repository.getScreenShots(game: game)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] screenshots in
               self?.screenShots = screenshots
            }
            .store(in: &cancellables)
    }
    
    /// Fetches similar games to a specific game.
    /// - Parameter game: The identifier of the game to fetch similar games for.
    func getSimilarGames(game: String) {
        repository.getGameSeries(game: game)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] gameSeries in
                self?.gameSeries = gameSeries.results
            }
            .store(in: &cancellables)
    }
}
