//
//  Async_await_with_URLSession.swift
//  async_await
//
//  Created by Alex on 17.12.25.
//


// View
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = GalleryViewModel(
        loader: ImageLoader_Model(),
        cache: CoreDataImageCache(context: CoreDataStack.shared.context),
        maxItems: 100
    )
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150, maximum: 600), spacing: nil, alignment: nil),
    ]
    
    var body: some View {
        
        Text("Items count: \(viewModel.items.count.description)")
            .padding()
        
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: nil) {
                ForEach(viewModel.items) {item in
                    AsyncImgView(imageURL: item.imageURL)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(currentItem: item)
                            }
                        }
                }
            }
            .padding(8)
        }
        .onAppear {
            viewModel.loadInitial()
        }
    }
}


#Preview {
    ContentView()
}
