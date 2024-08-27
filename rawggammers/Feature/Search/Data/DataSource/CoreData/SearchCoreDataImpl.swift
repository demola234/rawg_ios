//
//  SearchCoreDataImpl.swift
//  rawggammers
//
//  Created by Ademola Kolawole on 27/07/2024.
//

import Foundation
import CoreData

/// A singleton class responsible for managing the Core Data stack, providing access to the persistent container and context, and saving changes.
class CoreDataStack {
    
    /// A shared singleton instance of `CoreDataStack` for convenient access throughout the app.
    static let shared = CoreDataStack()
    
    /// Private initializer to prevent direct instantiation of `CoreDataStack`. Use the shared instance instead.
    private init() {}
    
    /// The persistent container that encapsulates the Core Data stack, including the model and the persistent store.
    /// - The container is lazily initialized with the name "SearchData".
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SearchData")
        
        // Load the persistent stores and handle any potential errors.
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    /// The main context for interacting with the Core Data store. This context is associated with the main queue and is used for performing read and write operations.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Saves any changes in the main context to the persistent store.
    /// - If the context has unsaved changes, it attempts to save them. Any errors during the saving process will cause the app to terminate with a fatal error.
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
