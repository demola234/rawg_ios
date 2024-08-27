//
//  FavoriteCoreData.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import CoreData

/// Singleton class that manages the Core Data stack for the `FavoriteData` model.
class FavoriteCoreDataStack {
    /// Shared instance of `FavoriteCoreDataStack`.
    static let shared = FavoriteCoreDataStack()
    
    private init() {}
    
    /// The Core Data persistent container used to manage the Core Data stack.
    ///
    /// - Note: This container is initialized with the name "FavoriteData" which should correspond to the Core Data model file name.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    /// The managed object context associated with the persistent container.
    ///
    /// - Note: This context is used for managing and interacting with Core Data objects.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Saves any changes in the managed object context to the persistent store.
    ///
    /// - Note: If the context has unsaved changes, it attempts to save them. If the save operation fails, it triggers a fatal error.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
