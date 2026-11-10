//
//  CashedPhoto_Identifiable.swift
//  async_await
//
//  Created by Alex on 13.01.26.
//

import Foundation

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
