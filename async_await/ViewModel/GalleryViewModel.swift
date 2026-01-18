//
//  ImageViewModel.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

// Combine для работы с сетью и async/await, верно?
// если закоментить Combine, то View Model does not  conform to ObservableObject protocol
import Combine
import SwiftUI

// View Model
@MainActor
final class GalleryViewModel: ObservableObject {
    
    @Published var items: [Photo] = []
    
    private let loader: ImageLoader_Model
    private let cache: ImageCacheProtocol
    private let maxItems: Int
    
    init(loader: ImageLoader_Model, cache: ImageCacheProtocol, maxItems: Int) {
        self.loader = loader
        self.cache = cache
        self.maxItems = maxItems
    }
    
    func loadInitial() {
        // делает fetchRequest из БД
        items = cache.loadImages()
        
        if items.isEmpty {
            Task {
                await loadMore()
            }
        }
    }
    
    func loadMore() async {
        guard items.count < maxItems else { return }
        
        do {
            let image = try await loader.loadImage()
            // Метод UIImage.jpegData(compressionQuality:) имеет сигнатуру: func jpegData(compressionQuality: CGFloat) -> Data?
            // то есть возвращает оционал Data?, то есть не каждая картинка может быть сконвертирована в JPEG, потому разворачиваю через guard let
            guard let data = image.jpegData(compressionQuality: 0.9) else { return }
            // вот здесь метод save сохраняет CachedPhoto + возвращает struct Photo и это закидывается в массив items
            let cached = cache.save(imageData: data)
            items.append(cached)
        } catch {
            print(error)
        }
    }
    
    func loadMoreIfNeeded(currentItem item: Photo) async {
        guard let last = items.last else { return }
        
        if item.id == last.id {
            await loadMore()
        }
    }
}
