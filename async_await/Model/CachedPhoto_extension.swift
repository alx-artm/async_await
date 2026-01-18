//
//  CashedPhoto_Identifiable.swift
//  async_await
//
//  Created by Alex on 13.01.26.
//

import Foundation

//extension CachedPhoto: Identifiable {} - это лишнее, так как если есть поле id: UUID() в сущности Core Data (CachedPhoto), то объект еще под капотом в автосгенерированных файлах будет Identifiable

// Маппинг — это преобразование одного типа данных в другой. Тут: превращение CachedPhoto в Photo. Обычно это нужно, когда есть слой кэша/хранилища и слой доменной логики, и нужно аккуратно разделить модели
extension CachedPhoto {
    func toDomain()-> Photo {
        // Формируем полный путь к файлу в папке Documents
        let fileName = self.imageFileName ?? ""
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appendingPathComponent(fileName)
        
        return Photo(
            id: self.id ?? UUID(),
            imageURL: url,
            createdAt: self.createdAt ?? Date()
        )
    }
}
