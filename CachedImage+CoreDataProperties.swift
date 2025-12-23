//
//  CachedImage+CoreDataProperties.swift
//  async_await
//
//  Created by Alex on 5.01.26.
//
//

public import Foundation
public import CoreData


public typealias CachedImageCoreDataPropertiesSet = NSSet

extension CachedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedImage> {
        return NSFetchRequest<CachedImage>(entityName: "CachedImage")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?

}

extension CachedImage : Identifiable {

}
