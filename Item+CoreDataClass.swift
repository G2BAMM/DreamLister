//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Brian McAulay on 28/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        
    }
}
