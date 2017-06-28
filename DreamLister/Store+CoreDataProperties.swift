//
//  Store+CoreDataProperties.swift
//  DreamLister
//
//  Created by Brian McAulay on 28/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var name: String?
    @NSManaged public var itemId: NSSet?
    @NSManaged public var imageId: Image?

}

// MARK: Generated accessors for itemId
extension Store {

    @objc(addItemIdObject:)
    @NSManaged public func addToItemId(_ value: Item)

    @objc(removeItemIdObject:)
    @NSManaged public func removeFromItemId(_ value: Item)

    @objc(addItemId:)
    @NSManaged public func addToItemId(_ values: NSSet)

    @objc(removeItemId:)
    @NSManaged public func removeFromItemId(_ values: NSSet)

}
