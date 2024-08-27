//
//  FavoriteRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine

/// Implementation of the `FavoriterRepository` protocol for managing favorite items.
///
/// This class provides methods to save, retrieve, delete, and check favorites using a local data source.
class FavoriteRepositoryImpl: FavoriterRepository {
    
    /// Shared instance of `FavoriteRepositoryImpl`.
    static let shared = FavoriteRepositoryImpl()
    
    /// Saves a favorite item to the local data source.
    ///
    /// - Parameter favorite: The `FavoriteEntity` to be saved.
    /// - Returns: A publisher emitting the saved `FavoriteEntity` or an error.
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
    
    /// Retrieves all favorite items from the local data source.
    ///
    /// - Returns: A publisher emitting an array of `FavoriteEntity` or an error.
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
    
    /// Deletes a favorite item from the local data source.
    ///
    /// - Parameter favorite: The `FavoriteEntity` to be deleted.
    /// - Returns: A publisher emitting the deleted `FavoriteEntity` or an error.
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
    
    /// Checks if an item with the specified name is marked as a favorite.
    ///
    /// - Parameter name: The name of the item to check.
    /// - Returns: A publisher emitting a boolean indicating if the item is a favorite or an error.
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
