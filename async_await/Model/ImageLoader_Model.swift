//
//  ImageLoader.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

// Model
import SwiftUI

final class ImageLoader_Model {
    
    func loadImage() async throws -> UIImage {
        let url = URL(string: "https://picsum.photos/600")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return image
    }
}
