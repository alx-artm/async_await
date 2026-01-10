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


protocol ImageCacheProtocol {
    func loadImages() -> [CachedPhoto]
    func save(imageData: Data) -> CachedPhoto
}

// View Model
@MainActor
final class GalleryViewModel: ObservableObject {
    
    @Published var items: [CachedPhoto] = []
    
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
            let data = image.jpegData(compressionQuality: 0.9)!
            let cached = cache.save(imageData: data)
            items.append(cached)
        } catch {
            print(error)
        }
    }
    
    func loadMoreIfNeeded(currentItem item: CachedPhoto) async {
        guard let last = items.last else { return }
        
        if item.id == last.id {
            await loadMore()
        }
    }
}
