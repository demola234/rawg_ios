//
//  HomeRepositoryImpl.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 26/07/2024.
//

import Foundation
import Combine


class HomeRepositoryImpl: HomeRepository {
    static let shared = HomeRepositoryImpl()
    
    func getGames(discover: Bool, ordering: String, filter: Bool, page: Int) -> AnyPublisher<[GamesEntity], Error> {
        return Future<[GamesEntity], Error> { promise in
            HomeRemoteDataSourceImpl.shared.getGames(discover: discover, ordering: ordering, filter: filter, page: page) { result in
                switch result {
                case .success(let games):
                    promise(.success(games))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
}
