//
//  FavoriterRepository.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine

protocol FavoriterRepository {
    func saveFavorite(favorite: FavoriteEntity) -> AnyPublisher<FavoriteEntity, Error>
    func getAllFavorites() -> AnyPublisher<[FavoriteEntity], Error>
    func deleteFavorite(favorite: FavoriteEntity) -> AnyPublisher<FavoriteEntity, Error>
}
