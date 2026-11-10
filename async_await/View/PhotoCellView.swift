//
//  AsyncImgView.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

import SwiftUI

struct PhotoCellView: View {
    let photo: Photo
    
    var body: some View {
        
        if let image = UIImage(contentsOfFile: photo.imageURL.path) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        } else {
            Color.gray.opacity(0.5)
                .frame(maxWidth: .infinity, minHeight: 150, maxHeight: .infinity)
                .overlay {
                    Text("Smth wrong with file...")
                        .fontWeight(.bold)
                        .padding()
                }
                .cornerRadius(10)
        }
    }
}
