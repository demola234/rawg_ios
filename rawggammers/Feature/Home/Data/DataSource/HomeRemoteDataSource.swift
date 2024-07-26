//
//  HomeRemoteDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


// MARK: - HomeRemoteDataSource
protocol HomeRemoteDataSource {
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    func getPlatForms(completion: @escaping (Result<PlatformsEntity, Error>) -> Void)
    func getGameDetails(game: String, completion: @escaping (Result<ResultData, Error>) -> Void)
    func getMovies(game: String, completion: @escaping (Result<MoviesEntity, Error>) -> Void)
    func getBestGameLastYear(year: Int, discover: Bool, ordering: String, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    func getGamesByPlatform(platform: Int, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
    func getBestGames(year: Int, discover: Bool, ordering: String, page: Int, completion: @escaping (Result<GamesEntity, Error>) -> Void)
}


class HomeRemoteDataSourceImpl: HomeRemoteDataSource {
    static let shared = HomeRemoteDataSourceImpl()
    private var cancellables = Set<AnyCancellable>()
    
    
    private let apiKey: String
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
}
