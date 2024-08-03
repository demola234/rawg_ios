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
    func checkIfFavorite(name: String, completion: @escaping (Result<Bool, Error>) -> Void)
}


class FavoriteLocalDataSourceImpl: FavoriteLocalDataSource {
    static let shared = FavoriteLocalDataSourceImpl(context: FavoriteCoreDataStack.shared.context)
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
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
      
    
    func deleteFavorite(favorite: FavoriteEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<FavoriteData> = FavoriteData.fetchRequest()
        request.predicate =  NSPredicate(format: "id == %@", favorite.id as CVarArg)
        
        do {
            let favorites = try self.context.fetch(request)
            favorites.forEach { context.delete($0) }
            try self.context.save()
            
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
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
