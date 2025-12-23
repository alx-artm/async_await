//
//  AsyncImgView.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//

import SwiftUI

struct AsyncImgView: View {
    var body: some View {
        ScrollView {
            VStack {
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                ForEach(0..<10) {_ in
                    
                    // первый вариант - через AsyncImage - асинхронно загружает
                    AsyncImage(url: URL(string: "https://picsum.photos/400")) { image in
                        image.resizable()
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .background(Rectangle()
                                .opacity(0.2)
                                .cornerRadius(10))
                    }
                    
                    // второй экземпляр AsyncImage
                    AsyncImage(url: URL(string: "https://picsum.photos/400")) { phase in
                        if let image = phase.image {
                            // Displays the loaded image.
                            image.resizable()
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fit)
                            
                        } else if phase.error != nil {
                            // Indicates an error.
                                Text("Error")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                                .background(
                                    .red
                                )
                                .cornerRadius(10)
                        } else {
                            // Acts as a placeholder.
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .background(Rectangle()
                                    .opacity(0.2)
                                    .cornerRadius(10))
                        }
                    }
                }
            }
            .padding()
        }
    }
}



#Preview {
    AsyncImgView()
}
