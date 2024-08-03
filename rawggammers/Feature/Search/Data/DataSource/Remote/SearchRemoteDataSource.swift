//
//  SearchRemoteDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


protocol SearchRemoteDataSource {
    func searchGames(query: String, page: Int, completion: @escaping (Result<SearchEntity, Error>) -> Void)
}


class SearchRemoteDataSourceImpl: SearchRemoteDataSource {

    
    static let shared = SearchRemoteDataSourceImpl()
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

    
    func searchGames(query: String, page: Int, completion: @escaping (Result<SearchEntity, Error>) -> Void) {
//        URL: https://api.rawg.io/api/games?key=8a275dde2a4f416e8931d049b981d6c4&filter=true&search=one+piece&page=1
        
        var urlComponents = URLComponents(string: "\(apiBaseURL)games")
        urlComponents?.queryItems = [
//                   URLQueryItem(name: "filter", value: String(filter)),
                   URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "key", value: apiKey),
                    URLQueryItem(name: "search", value: query.replacingOccurrences(of: " ", with: "+"))
               ]
        
        guard let url = urlComponents?.url else { return }
        
        let request = URLRequest(url: url)
        print("Request: \(request)")
        
        NetworkManager.getRequest(url: request)
            .decode(type: SearchEntity.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completionResponse in
                switch completionResponse {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(.failure(error as? NetworkError ?? .invalidResponse))
                case .finished:
                    break
                }
            } receiveValue: { searchResults in
                completion(.success(searchResults))
            }
            .store(in: &cancellables)
    }

}
