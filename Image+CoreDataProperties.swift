//
//  Image+CoreDataProperties.swift
//  DreamLister
//
//  Created by Brian McAulay on 10/07/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var imageId: Item?
    @NSManaged public var storeId: NSSet?

}

// MARK: Generated accessors for storeId
extension Image {

    @objc(addStoreIdObject:)
    @NSManaged public func addToStoreId(_ value: Store)

    @objc(removeStoreIdObject:)
    @NSManaged public func removeFromStoreId(_ value: Store)

    @objc(addStoreId:)
    @NSManaged public func addToStoreId(_ values: NSSet)

    @objc(removeStoreId:)
    @NSManaged public func removeFromStoreId(_ values: NSSet)

}
