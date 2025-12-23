//
//  ImageViewModel.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

import Combine
import SwiftUI


// Enum with associated value
enum ImageState {
    case loading
    case success (UIImage)
    case failure
}

// ВОПРОС - А ЧТО ЕСЛИ МОДЕЛЕЙ 2 ИЛИ БОЛЕЕ?? СКОЛЬКО ТОГДА ViewModel? Все в той же создаются экземпляры класса из Model? И почему именно Class в Model, а не Struct?

// View Model
@MainActor
final class ImageViewModel: ObservableObject {
    
    // почему именно @Published?
    @Published var state: ImageState = .loading
    
    private let loader = ImageLoader_Model()
    
    func load() async {
        state = .loading
        
        do {
            let image = try await loader.loadImage()
            state = .success(image)
        } catch {
            state = .failure
        }
    }
}
