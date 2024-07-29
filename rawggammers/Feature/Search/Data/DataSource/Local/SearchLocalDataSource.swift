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
}


class SearchLocalDataSourceImpl: SearchLocalDataSource {
    
    static let shared = SearchLocalDataSourceImpl(context: CoreDataStack.shared.context)
    private let context: NSManagedObjectContext
        
        init(context: NSManagedObjectContext) {
            self.context = context
        }
    
    
    func saveSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let search = SearchDataEntry(context: context)
        search.id = Int32(query.id ?? 0)
        search.name = query.name
        search.slug = query.slug
        search.backgroundImage = query.backgroundImage
        search.updatedAt = query.updated
        
        do {
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getAllSavedSearches(completion: @escaping (Result<[SearchDataEntity], Error>) -> Void) {
            let request: NSFetchRequest<SearchDataEntry> = SearchDataEntry.fetchRequest()
            do {
                let searches = try context.fetch(request)
                let searchEntities = searches.map { search in
                    SearchDataEntity(
                        slug: search.slug,
                        name: search.name,
                        backgroundImage: search.backgroundImage,
                        updated: search.updatedAt,
                        id: Int(search.id)
                    )
                }
                completion(.success(searchEntities))
            } catch {
                completion(.failure(error))
            }
    }
    
    func deleteSearch(query: SearchDataEntity, completion: @escaping (Result<Bool, Error>) -> Void) {
        let request: NSFetchRequest<SearchDataEntry> = SearchDataEntry.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", query.id ?? 0)
        
        do {
            let search = try context.fetch(request)
            search.forEach { context.delete($0) }
            try context.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
