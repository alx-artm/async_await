//
//  AsyncImgView.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

import SwiftUI

struct AsyncImgView: View {
    let imageURL: URL?
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            if let image = phase.image {
                // Displays the loaded image.
                image.resizable()
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } else if phase.error != nil {
                // Indicates an error.
                Color.gray.opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        Text("Error")
                            .fontWeight(.bold)
                    }
                
            } else {
                // Acts as a placeholder.
                ProgressView()
            }
        }
    }
}


//#Preview {
//    AsyncImgView()
//}
