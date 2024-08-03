//
//  SearchLocalDataSource.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import CoreData
import Combine

protocol SearchLocalDataSource {
    func saveSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAllSavedSearches(completion: @escaping (Result<[SearchDataEntity], Error>) -> Void)
    func deleteSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void)
}

class SearchLocalDataSourceImpl: SearchLocalDataSource {
    
    static let shared = SearchLocalDataSourceImpl(context: CoreDataStack.shared.context)
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
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
    
    func getAllSavedSearches(completion: @escaping (Result<[SearchDataEntity], Error>) -> Void) {
        let request: NSFetchRequest<SearchData> = SearchData.fetchRequest()
        
        do {
            let searches = try self.context.fetch(request)
            
            // Logging the fetched data for debugging
            print("Fetched searches: \(searches)")
            
            let searchEntities = searches.map({ SearchDataEntity(id: $0.id!, name: $0.name!) })
            
            print("Search Entities: \(searchEntities)")
            completion(.success(searchEntities))
        } catch {
            completion(.failure(error))
        }
    }


    
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
