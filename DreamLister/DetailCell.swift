//
//  DetailCell.swift
//  DreamLister
//
//  Created by Brian McAulay on 29/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit


class DetailCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumb: UIImageView!
    
    func configureCell(item: Item){
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_GB")
        numberFormatter.numberStyle = .currency
        let formattedPrice = numberFormatter.string(from: item.price as NSNumber)
        
        lblTitle.text = item.title
        lblPrice.text = formattedPrice
        lblDescription.text = item.details
        imgThumb.image = item.imageId?.image as? UIImage
    }
    
}
