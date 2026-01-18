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
    
    // паттерн DI(Dependency Injection)
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadImages() -> [Photo] {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.sortDescriptors = [
            //В Core Data поиск и сортировка происходят не в языке Swift, а внутри базы данных (SQLite). База данных не знает про Swift-свойства напрямую, она знает про "колонки" в таблице.
            // Key-Value Coding (KVC), можно еще так: #keyPath(CachedPhoto.createdAt)
            NSSortDescriptor(key: #keyPath(CachedPhoto.createdAt), ascending: true)
        ]
        let result = (try? context.fetch(request)) ?? []
        return result.map { $0.toDomain() }
    }
    
    func save(imageData: Data) -> Photo {
        let fileName = "\(UUID().uuidString).jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        // 1. Физическое сохранение (пишем байты на диск)
        try? imageData.write(to: fileURL)
        
        // 2. Запись в БД (пишем имя файла в Core Data)
        let image = CachedPhoto(context: context)
        image.id = UUID()
        image.createdAt = Date()
        image.imageFileName = fileName // String атрибут
        
        try? context.save()
        return image.toDomain()
    }
    
    // Функция удаления (пока не применяется нигде)
    func delete(photo: Photo) {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photo.id as CVarArg)
        
        if let result = try? context.fetch(request), let objectToDelete = result.first {
            // Удаляем файл с диска
            if let url = photo.imageURL {
                try? FileManager.default.removeItem(at: url)
            }
            
            // Удаляем из базы SQLite
            context.delete(objectToDelete)
            try? context.save()
        }
    }
}
