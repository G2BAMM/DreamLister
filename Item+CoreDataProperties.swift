//
//  Item+CoreDataProperties.swift
//  DreamLister
//
//  Created by Brian McAulay on 10/07/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var details: String?
    @NSManaged public var lastUpdated: NSDate?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var imageId: Image?
    @NSManaged public var storeId: Store?
    @NSManaged public var typeId: ItemType?

}
