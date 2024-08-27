//
//  FavoriteLocalDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import Combine
import CoreData

/// Protocol defining the methods for interacting with local storage for favorite items.
protocol FavoriteLocalDataSource {
    /// Saves a favorite item to the local storage.
    ///
    /// - Parameter favorite: The `FavoriteEntity` to be saved.
    /// - Parameter completion: A closure that is called with the result of the save operation.
    func saveFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Retrieves all favorite items from the local storage.
    ///
    /// - Parameter completion: A closure that is called with the result of fetching all favorite items.
    func getAllFavorites(completion: @escaping (Result<[FavoriteEntity], Error>) -> Void)
    
    /// Deletes a favorite item from the local storage.
    ///
    /// - Parameter favorite: The `FavoriteEntity` to be deleted.
    /// - Parameter completion: A closure that is called with the result of the delete operation.
    func deleteFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Checks if an item with the specified name is marked as a favorite.
    ///
    /// - Parameter name: The name of the item to check.
    /// - Parameter completion: A closure that is called with the result of the check operation.
    func checkIfFavorite(name: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

/// Implementation of the `FavoriteLocalDataSource` protocol using Core Data.
class FavoriteLocalDataSourceImpl: FavoriteLocalDataSource {
    /// Shared instance of `FavoriteLocalDataSourceImpl`.
    static let shared = FavoriteLocalDataSourceImpl(context: FavoriteCoreDataStack.shared.context)
    
    private let context: NSManagedObjectContext
    
    /// Initializes the `FavoriteLocalDataSourceImpl` with a Core Data context.
    ///
    /// - Parameter context: The `NSManagedObjectContext` to be used for Core Data operations.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Saves a favorite item to the local storage.
    ///
    /// - Parameter favorite: The `FavoriteEntity` to be saved.
    /// - Parameter completion: A closure that is called with the result of the save operation.
    func saveFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let favorites = FavoriteData(context: context)
        favorites.id = favorite.id
        favorites.name = favorite.name
        favorites.slug = favorite.slug
        favorites.backgroundImage = favorite.backgroundImage
        favorites.rating = Double(favorite.rating ?? 0.0)
        favorites.reviewsCount = Int32(favorite.reviewsCount ?? 0)
        favorites.released = favorite.released
        favorites.updatedAt = favorite.updated
        favorites.suggestionsCount = Int32(favorite.suggestionsCount ?? 0)

        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Retrieves all favorite items from the local storage.
    ///
    /// - Parameter completion: A closure that is called with the result of fetching all favorite items.
    func getAllFavorites(completion: @escaping (Result<[FavoriteEntity], Error>) -> Void) {
        context.perform {
            let request: NSFetchRequest<FavoriteData> = FavoriteData.fetchRequest()
            do {
                let favorites = try self.context.fetch(request)
                let favoriteEntities = favorites.compactMap { favorite -> FavoriteEntity? in
                    guard let id = favorite.id, let slug = favorite.slug, let name = favorite.name else { return nil }
                    return FavoriteEntity(id: id, slug: slug, name: name, released: favorite.released, backgroundImage: favorite.backgroundImage, rating: favorite.rating, playtime: nil, suggestionsCount: Int(favorite.suggestionsCount), updated: favorite.updatedAt, reviewsCount: Int(favorite.reviewsCount))
                }
                DispatchQueue.main.async {
                    completion(.success(favoriteEntities))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Deletes a favorite item from the local storage.
    ///
    /// - Parameter favorite: The `FavoriteEntity` to be deleted.
    /// - Parameter completion: A closure that is called with the result of the delete operation.
    func deleteFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<FavoriteData> = FavoriteData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", favorite.id as CVarArg)
        
        do {
            let favorites = try self.context.fetch(request)
            favorites.forEach { context.delete($0) }
            try self.context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Checks if an item with the specified name is marked as a favorite.
    ///
    /// - Parameter name: The name of the item to check.
    /// - Parameter completion: A closure that is called with the result of the check operation.
    func checkIfFavorite(name: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<FavoriteData> = FavoriteData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let count = try self.context.count(for: request)
            completion(.success(count > 0))
        } catch {
            completion(.failure(error))
        }
    }
}
