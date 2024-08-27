//
//  SearchLocalDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import CoreData
import Combine

/// Protocol that defines the methods for interacting with the local data source for search entities.
/// Implementers are responsible for saving, retrieving, and deleting search queries.
protocol SearchLocalDataSource {
    
    /// Saves a search query locally.
    /// - Parameters:
    ///   - query: The search data entity to save.
    ///   - completion: A completion handler with a result indicating success or failure.
    func saveSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void)
    
    /// Retrieves all saved search queries from the local data store.
    /// - Parameters:
    ///   - completion: A completion handler with a result containing an array of `SearchDataEntity` or an error.
    func getAllSavedSearches(completion: @escaping (Result<[SearchDataEntity], Error>) -> Void)
    
    /// Deletes a saved search query from the local data store.
    /// - Parameters:
    ///   - query: The search data entity to delete.
    ///   - completion: A completion handler with a result indicating success or failure.
    func deleteSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void)
}

/// Implementation of `SearchLocalDataSource` for handling Core Data operations related to search queries.
class SearchLocalDataSourceImpl: SearchLocalDataSource {
    
    /// A shared singleton instance of `SearchLocalDataSourceImpl`.
    static let shared = SearchLocalDataSourceImpl(context: CoreDataStack.shared.context)
    
    /// The Core Data managed object context used to perform read/write operations.
    private let context: NSManagedObjectContext
    
    /// Initializes a new instance of `SearchLocalDataSourceImpl`.
    /// - Parameters:
    ///   - context: The managed object context used for Core Data operations.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Saves a search query to the Core Data store.
    /// - Parameters:
    ///   - query: The `SearchDataEntity` to be saved.
    ///   - completion: A completion handler that returns a success with `true` or a failure with an error.
    func saveSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let search = SearchData(context: context)
        search.name = query.name
        search.id = query.id
        
        do {
            try self.context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Retrieves all saved search queries from the Core Data store.
    /// - Parameters:
    ///   - completion: A completion handler that returns an array of `SearchDataEntity` or an error.
    func getAllSavedSearches(completion: @escaping (Result<[SearchDataEntity], Error>) -> Void) {
        let request: NSFetchRequest<SearchData> = SearchData.fetchRequest()
        
        do {
            let searches = try self.context.fetch(request)
            
            // Maps the fetched `SearchData` objects to `SearchDataEntity`.
            let searchEntities = searches.map { SearchDataEntity(id: $0.id!, name: $0.name!) }
            
            completion(.success(searchEntities))
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Deletes a specific search query from the Core Data store.
    /// - Parameters:
    ///   - query: The `SearchDataEntity` to delete.
    ///   - completion: A completion handler that returns a success with `true` or a failure with an error.
    func deleteSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<SearchData> = SearchData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", query.id as CVarArg)
        
        do {
            let searches = try self.context.fetch(request)
            searches.forEach { context.delete($0) }
            try self.context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
