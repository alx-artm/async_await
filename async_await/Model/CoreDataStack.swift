//
//  CoreDataStack.swift
//  async_await
//
//  Created by Alex on 8.01.26.
//

import CoreData

// Gemini предлагал struct CoreDataStack и указал, что при использовании Core Data в новом  проекте Apple сама ставить структуру (она более легковесная: не нужны наследования и деинициализации, труднее изменить структуру). GPT - final class (он также не наследуется)

// нужен класс-синглтон, который "поднимет" базу данных. Это стандартный шаблонный код (boilerplate)
final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer
    
// MARK: WARNING: ЧТОБЫ НА РЕАЛЬНОМ ДЕВАЙСЕ РАБОТАЛО - НУЖНО УСТАНОВИТЬ FALSE, иначе строки-адреса будут храниться в оперативке и не будет persistence (при закрытии приложения ссылки на файлы в БД не сохранятся, хотя файлы будут на диске в файловой системе приложения, в папке приложения)! Тут стоит true чтобы работало #preview, так как без этого превью крашится
    private init(inMemory: Bool = true) {
        //имя должно совпадать с названием файла .xcdatamodeld
        container = NSPersistentContainer(name: "ImageModel")
        
        // что это? Gemini
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // нужно пояснение для этого (это что?): автоматически объединять изменения, если сохраняем из разных потоков
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // вспомогательная функция для сохранения - почему вспомогательная? когда именно ее нужно вызывать?
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Something went wrong: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
}

