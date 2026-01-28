//
//  CoreDataStack.swift
//  async_await
//
//  Created by Alex on 8.01.26.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        //имя должно совпадать с названием файла .xcdatamodeld
        container = NSPersistentContainer(name: "ImageModel")
        
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        if inMemory {
            let description = container.persistentStoreDescriptions.first
            description?.url = URL(fileURLWithPath: "/dev/null")
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Something went wrong: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
}

