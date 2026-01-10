//
//  PhotoCell.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//
import SwiftUI

struct PhotoCellView: View {
    
    @StateObject private var viewModel = ImageViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                Rectangle()
                    .fill(.gray.opacity(0.6))
                    .overlay(ProgressView())
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                
            case .failure:
                Rectangle()
                    .fill(.red.opacity(0.6))
                    .overlay(
                        VStack {
                            Image(systemName: "xmark.circle")
                                .font(.largeTitle)
                            Text("failure")
                        }
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

