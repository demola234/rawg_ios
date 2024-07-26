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
    
    func searchGames(query: String) -> AnyPublisher<SearchEntity, Error> {
        
        return Future<SearchEntity, Error> { promise in
            SearchRemoteDataSourceImpl.shared.searchGames(query: query) { result in
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
