//
//  SearchRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine

class SearchRepositoryImpl: SearchRepository {
    static let shared = SearchRepositoryImpl()
    
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
