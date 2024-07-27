//
//  FavoriteRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine

class FavoriteRepositoryImpl: FavoriterRepository {
        
        private let favoriteLocalDataSource: FavoriteLocalDataSource
        
        init(favoriteLocalDataSource: FavoriteLocalDataSource) {
            self.favoriteLocalDataSource = favoriteLocalDataSource
        }
        
        func saveFavorite(favorite: FavoriteEntity) -> AnyPublisher<FavoriteEntity, Error> {
            return Future<FavoriteEntity, Error> { completion in
                self.favoriteLocalDataSource.saveFavorite(favorite: favorite) { result in
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
                self.favoriteLocalDataSource.getAllFavorites { result in
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
                self.favoriteLocalDataSource.deleteFavorite(favorite: favorite) { result in
                    switch result {
                    case .success:
                        completion(.success(favorite))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.eraseToAnyPublisher()
        }
}
