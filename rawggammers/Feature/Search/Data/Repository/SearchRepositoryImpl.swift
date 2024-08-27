//
//  SearchRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

/// An implementation of the `SearchRepository` protocol, responsible for handling the search operations including fetching and saving search data.
class SearchRepositoryImpl: SearchRepository {
    
    /// A shared singleton instance of `SearchRepositoryImpl` for convenient access throughout the app.
    static let shared = SearchRepositoryImpl()
    
    /// Searches games based on the provided query and page number.
    /// - Parameters:
    ///   - query: The search query string to search games by.
    ///   - page: The page number for pagination of search results.
    /// - Returns: A publisher that emits either a `SearchEntity` containing the search results or an error.
    func searchGames(query: String, page: Int) -> AnyPublisher<SearchEntity, Error> {
        return Future<SearchEntity, Error> { promise in
            SearchRemoteDataSourceImpl.shared.searchGames(query: query, page: page) { result in
                switch result {
                case .success(let search):
                    promise(.success(search))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Saves a search query to local storage.
    /// - Parameter query: The search query to save as a `SearchDataEntity`.
    /// - Returns: A publisher that emits either a boolean indicating success or failure, or an error.
    func saveSearch(query: SearchDataEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            SearchLocalDataSourceImpl.shared.saveSearch(query: query) { result in
                switch result {
                case .success(let search):
                    promise(.success(search))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Retrieves all saved search queries from local storage.
    /// - Returns: A publisher that emits either an array of `SearchDataEntity` objects or an error.
    func getAllSavedSearches() -> AnyPublisher<[SearchDataEntity], Error> {
        return Future<[SearchDataEntity], Error> { promise in
            SearchLocalDataSourceImpl.shared.getAllSavedSearches { result in
                switch result {
                case .success(let searches):
                    promise(.success(searches))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// Deletes a saved search query from local storage.
    /// - Parameter query: The search query to delete as a `SearchDataEntity`.
    /// - Returns: A publisher that emits either a boolean indicating success or failure, or an error.
    func deleteSearch(query: SearchDataEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            SearchLocalDataSourceImpl.shared.deleteSearch(query: query) { result in
                switch result {
                case .success(let search):
                    promise(.success(search))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
