//
//  CoreDataImageCache.swift
//  async_await
//
//  Created by Alex on 8.01.26.
//

import CoreData
import Foundation

protocol ImageCacheProtocol {
    func loadImages() -> [Photo]
    func save(imageData: Data) -> Photo
}

final class CoreDataImageCache: ImageCacheProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadImages() -> [Photo] {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(CachedPhoto.createdAt), ascending: true)
        ]
        
        do {
            let result = try context.fetch(request)
            return result.map { $0.toDomain() }
        } catch {
            print("Core Data fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    func save(imageData: Data) -> Photo {
        let newID = UUID()
        
        let fileName = "\(newID.uuidString).jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        // 1. Физическое сохранение (пишем байты на диск)
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Can't write to disk: \(error.localizedDescription)")
        }
        
        let image = CachedPhoto(context: context)
        image.id = newID
        image.createdAt = Date()
        image.imageFileName = fileName
        
        do {
            try context.save()
        } catch {
            print("Can't save to Core Data: \(error.localizedDescription)")
        }
        
        return image.toDomain()
    }
    
    func delete(photo: Photo) {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photo.id as CVarArg)
        
        do {
            let result = try context.fetch(request)
            if let objectToDelete = result.first {
                
                do {
                    try FileManager.default.removeItem(at: photo.imageURL)
                } catch {
                    print("can't delete file from disk: \(error.localizedDescription)")
                }
                
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch {
                    print("can't delete from CoreData: \(error.localizedDescription)")
                }
            }
        } catch {
            print(": \(error)")
        }
    }
}
