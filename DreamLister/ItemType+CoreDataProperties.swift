//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Brian McAulay on 28/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var typeId: Item?

}
