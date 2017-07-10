//
//  DetailCell.swift
//  DreamLister
//
//  Created by Brian McAulay on 29/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit
import CoreData

class DetailCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    
    @IBOutlet weak var lblLastUpdated: UILabel!
    @IBOutlet weak var lblDateAdded: UILabel!
    @IBOutlet weak var lblItemType: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    func configureCell(item: Item){
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_GB")
        numberFormatter.numberStyle = .currency
        let formattedPrice = numberFormatter.string(from: item.price as NSNumber)
        
        let storeName = item.storeId?.name as String!
        let itemType = item.typeId?.type as String!
        lblTitle.text = item.title
        lblPrice.text = formattedPrice
        lblDescription.text = item.details
        lblStoreName.text = (storeName == nil ? "Select Store" : storeName!)
        lblItemType.text = (itemType == nil ? "Select Type" : itemType!)
        imgThumb.image = item.imageId?.image as? UIImage
        if imgThumb.image == nil{
            //Always make sure we have a thumbnail even if none was saved with this item
            imgThumb.image = UIImage(named: "imagePick")
        }
        lblLastUpdated.text = getTimeDifference(dateToCheck: item.lastUpdated! as Date)
        lblDateAdded.text = formatDate(dateToBeFormatted: item.created! as Date)
        //print("Inserted: \(item.created!) Updated: \(item.lastUpdated!)")
    }
    
}
