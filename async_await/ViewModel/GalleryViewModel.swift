//
//  ImageViewModel.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

import Combine
import SwiftUI

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
            guard let data = image.jpegData(compressionQuality: 0.9) else { return }
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
