//
//  FavoriteRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine

class FavoriteRepositoryImpl: FavoriterRepository {
    static let shared = FavoriteRepositoryImpl()
    
        
        func saveFavorite(favorite: FavoriteEntity) -> AnyPublisher<FavoriteEntity, Error> {
            return Future<FavoriteEntity, Error> { completion in
                FavoriteLocalDataSourceImpl.shared.saveFavorite(favorite: favorite) { result in
                    switch result {
                    case .success:
                        completion(.success(favorite))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        func getAllFavorites() -> AnyPublisher<[FavoriteEntity], Error> {
            return Future<[FavoriteEntity], Error> { completion in
                FavoriteLocalDataSourceImpl.shared.getAllFavorites() { result in
                    switch result {
                    case .success(let favorites):
                        completion(.success(favorites))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        func deleteFavorite(favorite: FavoriteEntity) -> AnyPublisher<FavoriteEntity, Error> {
            return Future<FavoriteEntity, Error> { completion in
                FavoriteLocalDataSourceImpl.shared.deleteFavorite(favorite: favorite) { result in
                    switch result {
                    case .success:
                        completion(.success(favorite))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.eraseToAnyPublisher()
        }
    
    func checkIfFavorite(name: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            FavoriteLocalDataSourceImpl.shared.checkIfFavorite(name: name) { result in
                switch result {
                case .success(let isFavorite):
                    completion(.success(isFavorite))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
