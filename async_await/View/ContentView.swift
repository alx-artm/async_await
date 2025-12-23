//
//  Async_await_with_URLSession.swift
//  async_await
//
//  Created by Alex on 17.12.25.
//


// View
import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150, maximum: 600), spacing: nil, alignment: nil),
        //GridItem(.adaptive(minimum: 200, maximum: 600), spacing: nil, alignment: nil)
    ]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: nil) {
                ForEach(0..<20) {_ in
                    PhotoCellView()
                }
            }
            .padding(8)
        }
    }
}


#Preview {
    ContentView()
}
