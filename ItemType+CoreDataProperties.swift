//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Brian McAulay on 10/07/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var typeId: NSSet?

}

// MARK: Generated accessors for typeId
extension ItemType {

    @objc(addTypeIdObject:)
    @NSManaged public func addToTypeId(_ value: Item)

    @objc(removeTypeIdObject:)
    @NSManaged public func removeFromTypeId(_ value: Item)

    @objc(addTypeId:)
    @NSManaged public func addToTypeId(_ values: NSSet)

    @objc(removeTypeId:)
    @NSManaged public func removeFromTypeId(_ values: NSSet)

}
