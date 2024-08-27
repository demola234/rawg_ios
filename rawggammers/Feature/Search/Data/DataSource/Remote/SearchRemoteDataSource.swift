//
//  SearchRemoteDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

/// Protocol that defines the methods for interacting with the remote data source for search queries.
/// Implementers are responsible for fetching game search results from a remote server.
protocol SearchRemoteDataSource {
    
    /// Fetches games from the remote server based on the given search query.
    /// - Parameters:
    ///   - query: The search string to query the games.
    ///   - page: The page number for pagination.
    ///   - completion: A completion handler with a result containing either a `SearchEntity` object or an error.
    func searchGames(query: String, page: Int, completion: @escaping (Result<SearchEntity, Error>) -> Void)
}

/// Implementation of `SearchRemoteDataSource` for handling remote search operations via network requests.
class SearchRemoteDataSourceImpl: SearchRemoteDataSource {
    
    /// A shared singleton instance of `SearchRemoteDataSourceImpl`.
    static let shared = SearchRemoteDataSourceImpl()
    
    /// A set to store Combine cancellables.
    private var cancellables = Set<AnyCancellable>()
    
    /// The API key for authentication with the remote server.
    private let apiKey: String
    
    /// The base URL for the remote server.
    private let apiBaseURL: String
    
    /// Initializes the `SearchRemoteDataSourceImpl` and retrieves the API key and base URL from the app's `Info.plist`.
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
    
    /// Fetches games from the remote server based on the search query and page number.
    /// - Parameters:
    ///   - query: The search string for querying the games.
    ///   - page: The page number for the paginated search results.
    ///   - completion: A completion handler that returns either a `SearchEntity` object containing the search results or an error.
    func searchGames(query: String, page: Int, completion: @escaping (Result<SearchEntity, Error>) -> Void) {
        
        // Constructs the URL with query parameters for the search.
        var urlComponents = URLComponents(string: "\(apiBaseURL)games")
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "search", value: query.replacingOccurrences(of: " ", with: "+"))
        ]
        
        // Validates the URL.
        guard let url = urlComponents?.url else { return }
        
        let request = URLRequest(url: url)
        print("Request: \(request)")
        
        // Sends the network request and decodes the response.
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
