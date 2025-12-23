//
//  CoreDataImageCache.swift
//  async_await
//
//  Created by Alex on 8.01.26.
//

import CoreData
import Foundation

final class CoreDataImageCache: ImageCacheProtocol {
    
    private let context = CoreDataStack.shared.context
    
    func loadImages() -> [CachedPhoto] {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.sortDescriptors = [
            // а почему так? "createdAt" - это же свойство объекта с Date? а тут key: String
            // или назвать можно как угодно, главгное, что ascending: true?
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        return (try? context.fetch(request)) ?? []
    }
    
    func save(imageData: Data) -> CachedPhoto {
        let image = CachedPhoto(context: context)
        image.id = UUID()
        image.imageData = imageData
        image.createdAt = Date()
        
        try? context.save()
        return image
    }
}
