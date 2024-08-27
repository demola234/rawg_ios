//
//  HomeRemoteDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


// MARK: - HomeRemoteDataSource

/// A protocol defining methods for fetching remote data related to games from an API.
protocol HomeRemoteDataSource {
    
    /// Fetches a list of games based on various parameters.
    /// - Parameters:
    ///   - discover: A Boolean value indicating whether to discover new games.
    ///   - ordering: A string specifying the ordering of the games.
    ///   - filter: A Boolean value indicating whether to apply filters.
    ///   - page: The page number for pagination.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `GamesEntity` or an `Error`.
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    
    /// Fetches a list of platforms.
    /// - Parameters:
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `PlatformsEntity` or an `Error`.
    func getPlatForms(completion: @escaping (Result<PlatformsEntity, Error>) -> Void)
    
    /// Fetches details of a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch details for.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `ResultData` or an `Error`.
    func getGameDetails(game: String, completion: @escaping (Result<ResultData, Error>) -> Void)
    
    /// Fetches movies related to a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch movies for.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `MoviesEntity` or an `Error`.
    func getMovies(game: String, completion: @escaping (Result<MoviesEntity, Error>) -> Void)
    
    /// Fetches the best games from the last year based on various parameters.
    /// - Parameters:
    ///   - year: The year to fetch the best games from.
    ///   - discover: A Boolean value indicating whether to discover new games.
    ///   - ordering: A string specifying the ordering of the games.
    ///   - page: The page number for pagination.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `GamesEntity` or an `Error`.
    func getBestGameLastYear(year: Int, discover: Bool, ordering: String, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    
    /// Fetches games available on a specific platform.
    /// - Parameters:
    ///   - platform: The identifier of the platform to fetch games for.
    ///   - page: The page number for pagination.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `GamesEntity` or an `Error`.
    func getGamesByPlatform(platform: Int, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    
    /// Fetches the best games for a specific year based on various parameters.
    /// - Parameters:
    ///   - year: The year to fetch the best games for.
    ///   - discover: A Boolean value indicating whether to discover new games.
    ///   - ordering: A string specifying the ordering of the games.
    ///   - page: The page number for pagination.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `GamesEntity` or an `Error`.
    func getBestGames(year: Int, discover: Bool, ordering: String, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    
    /// Fetches screenshots of a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch screenshots for.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `GameScreenShotsEntity` or an `Error`.
    func getScreenShots(game: String, completion: @escaping (Result<GameScreenShotsEntity, Error>) -> Void)
    
    /// Fetches the series of a specific game.
    /// - Parameters:
    ///   - game: The identifier of the game to fetch the series for.
    ///   - completion: A closure to be executed once the request completes. The closure takes a `Result` containing either a `GamesEntity` or an `Error`.
    func getGameSeries(game: String, completion: @escaping (Result<GamesEntity, Error>) -> Void)
}


// MARK: - HomeRemoteDataSourceImpl

/// A concrete implementation of the `HomeRemoteDataSource` protocol, handling network requests to fetch game-related data.
class HomeRemoteDataSourceImpl: HomeRemoteDataSource {

    /// Shared instance for singleton access.
    static let shared = HomeRemoteDataSourceImpl()
    
    /// A set of cancellable subscriptions used to manage Combine publishers.
    private var cancellables = Set<AnyCancellable>()
    
    /// The API key used for authentication with the API.
    private let apiKey: String
    
    /// The base URL for API requests.
    private let apiBaseURL: String
    
    private init() {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        guard let apiBaseURL = Bundle.main.infoDictionary?["API_BASE_URL"] as? String else {
            fatalError("API_BASE_URL not found in Info.plist")
        }
        self.apiKey = apiKey
        self.apiBaseURL = apiBaseURL
    }

    func getPlatForms(completion: @escaping (Result<PlatformsEntity, Error>) -> Void) {
        let request = URLRequest(url: URL(string: "\(apiBaseURL)platforms/lists/parents?key=\(apiKey)")!)
        
        NetworkManager.getRequest(url: request)
            .decode(type: PlatformsEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { platforms in
                print("Platforms: \(platforms)")
                completion(.success(platforms))
            }
            .store(in: &cancellables)
    }
    
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void) {
        var urlComponents = URLComponents(string: "\(apiBaseURL)games/lists/main")
        urlComponents?.queryItems = [
            URLQueryItem(name: "discover", value: String(discover)),
            URLQueryItem(name: "ordering", value: ordering),
            URLQueryItem(name: "filter", value: String(filter)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = urlComponents?.url else { return }
        
        let request = URLRequest(url: url)
        print("Request: \(request)")
        
        NetworkManager.getRequest(url: request)
            .decode(type: GamesEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: here \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { games in
                print("Games: \(games)")
                completion(.success(games))
            }
            .store(in: &cancellables)
    }
    
    func getGameDetails(game: String, completion: @escaping (Result<ResultData, Error>) -> Void) {
        var urlComponents = URLComponents(string: "\(apiBaseURL)games/\(game)")
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "filter", value: "true")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        let request = URLRequest(url: url)
        
        print("Request: \(request)")
        
        NetworkManager.getRequest(url: request)
            .decode(type: ResultData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { gameDetails in
                print("Game Details: \(gameDetails)")
                completion(.success(gameDetails))
            }
            .store(in: &cancellables)
    }
    
    func getMovies(game: String, completion: @escaping (Result<MoviesEntity, Error>) -> Void) {
        let request = URLRequest(url: URL(string: "\(apiBaseURL)games/\(game)/movies?key=\(apiKey)&filter=true")!)
        
        NetworkManager.getRequest(url: request)
            .decode(type: MoviesEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { movies in
                print("Movies: \(movies)")
                completion(.success(movies))
            }
            .store(in: &cancellables)
    }
    
    func getBestGameLastYear(year: Int, discover: Bool, ordering: String, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void) {
        let url = URL(string: "\(apiBaseURL)games/lists/greatest?year=\(year)&discover=\(discover)&ordering=\(ordering)&page_size=20&key=\(apiKey)&filter=true&page=\(page)")!
        
        let request = URLRequest(url: url)
        
        NetworkManager.getRequest(url: request)
            .decode(type: GamesEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { games in
                print("Games: \(games)")
                completion(.success(games))
            }
            .store(in: &cancellables)
    }
    
    func getGamesByPlatform(platform: Int, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void) {
        let url = URL(string: "\(apiBaseURL)games?parent_platforms=\(platform)&key=\(apiKey)&filter=true&page=\(page)")!
        
        let request = URLRequest(url: url)
        
        NetworkManager.getRequest(url: request)
            .decode(type: GamesEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { games in
                print("Games: \(games)")
                completion(.success(games))
            }
            .store(in: &cancellables)
    }
    
    func getBestGames(year: Int, discover: Bool, ordering: String, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void) {
        let url = URL(string: "\(apiBaseURL)games?key=\(apiKey)&filter=true&dates=\(year)-01-01,\(year)-12-31&page=\(page)")!
        
        let request = URLRequest(url: url)
        
        NetworkManager.getRequest(url: request)
            .decode(type: GamesEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { games in
                print("Games: \(games)")
                completion(.success(games))
            }
            .store(in: &cancellables)
    }
    
    func getScreenShots(game: String, completion: @escaping (Result<GameScreenShotsEntity, Error>) -> Void) {
        let request = URLRequest(url: URL(string: "\(apiBaseURL)games/\(game)/screenshots?key=\(apiKey)&filter=true")!)
        
        NetworkManager.getRequest(url: request)
            .decode(type: GameScreenShotsEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { screenshots in
                print("Screenshots: \(screenshots)")
                completion(.success(screenshots))
            }
            .store(in: &cancellables)
    }
    
    func getGameSeries(game: String, completion: @escaping (Result<GamesEntity, Error>) -> Void) {
        let request = URLRequest(url: URL(string: "\(apiBaseURL)games/\(game)/game-series?key=\(apiKey)&filter=true")!)
        
        NetworkManager.getRequest(url: request)
            .decode(type: GamesEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { gameSeries in
                print("Game Series: \(gameSeries)")
                completion(.success(gameSeries))
            }
            .store(in: &cancellables)
    }
}
