//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Brian McAulay on 28/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        let date = Date()
        var summerTime: Date?
        let tz = NSTimeZone.local
        if tz.isDaylightSavingTime(for: date){
            //We need to add an hour to our date as we're in BST (UK) or daylight savings elsewhere
            summerTime = Calendar.current.date(byAdding:.hour, value: 1, to: Date())
            print("Used daylight savings")
        }else{
            //No daylight savings in operation so just use the current date GMT (UK)
            summerTime = Date()
            print("Did not use daylight savings")
        }

        self.created = summerTime! as NSDate
    }
}
