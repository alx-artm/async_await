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
        
        do {
            // Выполняем запрос в БД
            let result = try context.fetch(request)
            return result.map { $0.toDomain() }
        } catch {
            // Логируем ошибку
            print("Core Data fetch error: \(error.localizedDescription)")
            // Возвращаем пустой массив чтобы приложение не упало
            return []
        }
    }
    
    func save(imageData: Data) -> Photo {
        let fileName = "\(UUID().uuidString).jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        // 1. Физическое сохранение (пишем байты на диск)
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Can't write to disk: \(error.localizedDescription)")
        }
        
        // 2. Запись в БД (пишем имя файла в Core Data)
        let image = CachedPhoto(context: context)
        image.id = UUID()
        image.createdAt = Date()
        image.imageFileName = fileName // String атрибут
        
        do {
            try context.save()
        } catch {
            print("Can't save to Core Data: \(error.localizedDescription)")
        }
        
        return image.toDomain()
    }
    
    // Функция удаления (пока не применяется нигде)
    func delete(photo: Photo) {
        let request: NSFetchRequest<CachedPhoto> = CachedPhoto.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photo.id as CVarArg)
        
        do {
            let result = try context.fetch(request)
            if let objectToDelete = result.first {
                
                // Удаляем файл с диска
                do {
                    try FileManager.default.removeItem(at: photo.imageURL)
                } catch {
                    print("can't delete file from disk: \(error.localizedDescription)")
                }
                
                // Удаляем из базы SQLite
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
