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
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int, completion: @escaping (Result<[GamesEntity], Error>) -> Void)
}


class HomeRemoteDataSourceImpl: HomeRemoteDataSource {
    static let shared = HomeRemoteDataSourceImpl()
    private var cancellables = Set<AnyCancellable>()
    
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int, completion: @escaping (Result<[GamesEntity], Error>) -> Void) {
        // Url: https://api.rawg.io/api/games/lists/main?discover=true&ordering=-relevance&key=8a275dde2a4f416e8931d049b981d6c4&filter=true&page=1
        let apiKey = "8a275dde2a4f416e8931d049b981d6c4"
        
        var urlComponents = URLComponents(string: "https://api.rawg.io/api/games/lists/main")
        urlComponents?.queryItems = [
                   URLQueryItem(name: "discover", value: String(discover)),
                   URLQueryItem(name: "ordering", value: ordering),
                   URLQueryItem(name: "filter", value: String(filter)),
                   URLQueryItem(name: "page", value: String(page)),
                   URLQueryItem(name: "key", value: apiKey)
               ]
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        
        
        NetworkManager.getRequest(url: request)
            .decode(type: [GamesEntity].self, decoder: JSONDecoder())
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
                completion(.success(games))
            }
            .store(in: &cancellables)

    }
}
