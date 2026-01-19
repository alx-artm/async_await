//
//  PhotoCell.swift
//  async_await
//
//  Created by Alex on 22.12.25.
//
import SwiftUI

// СЕЙЧАС В ТЕКУЩЕМ КОДЕ НЕ ИСПОЛЬЗУЕТСЯ ЭТА ВЬЮШКА
struct PhotoCellView: View {
    
    let imageData: Data
    
    // передаем бинарную Data в UIImage и присваиваем в let image, а затем создаем вьюшку, куда передаем UIImage, верно?
    // можно ли сразу делать вью UIImage(data: imageData)? или не правильно т.к. возможнен краш, потому сначала распаковка опционала?
    var body: some View {
        if let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        } else {
            Color.gray
                .opacity(0.5)
        }
    }
}

