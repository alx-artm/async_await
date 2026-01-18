//
//  Photo.swift
//  async_await
//
//  Created by Alex on 14.01.26.
//

import Foundation

// Domain model
struct Photo: Identifiable, Equatable {
    let id: UUID
    let imageURL: URL?
    let createdAt: Date
}
