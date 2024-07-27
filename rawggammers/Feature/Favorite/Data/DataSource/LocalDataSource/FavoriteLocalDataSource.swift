//
//  FavoriteLocalDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine
import CoreData

protocol FavoriteLocalDataSource {
    func saveFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAllFavorites(completion: @escaping (Result<[FavoriteEntity], Error>) -> Void)
    func deleteFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void)
}


class FavoriteLocalDataSourceImpl: FavoriteLocalDataSource {

    static let shared = FavoriteLocalDataSourceImpl(context: FavoriteCoreDataStack.shared.context)
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let favorite = FavoriteDataEntry(context: context)
        favorite.id = Int32(favorite.id)
        favorite.name = favorite.name
        favorite.slug = favorite.slug
        favorite.backgroundImage = favorite.backgroundImage
        favorite.updated = favorite.updated
        
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getAllFavorites(completion: @escaping (Result<[FavoriteEntity], Error>) -> Void) {
        let request: NSFetchRequest<FavoriteDataEntry> = FavoriteDataEntry.fetchRequest()
        do {
            let favorites = try context.fetch(request)
            let favoriteEntities = favorites.map { favorite in
                FavoriteEntity(
                    id: Int(favorite.id),
                    slug: favorite.slug, name: favorite.name,
                    released: favorite.released,
                    backgroundImage: favorite.backgroundImage,
                    rating: Double(favorite.rating),
                    ratingTop:  Int(favorite.reviewsCount),
                    playtime: Int(favorite.rating),
                    suggestionsCount: Int(favorite.ratingTop),
                    updated: favorite.updated,
                    reviewsCount: Int(favorite.suggestionsCount)
                )
            }
            completion(.success(favoriteEntities))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<FavoriteDataEntry> = FavoriteDataEntry.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", favorite.id ?? 0)
        
        do {
            let favorites = try context.fetch(request)
            for favorite in favorites {
                context.delete(favorite)
            }
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
}
