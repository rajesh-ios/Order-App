//
//  QuickMenuCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 4/3/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class QuickMenuCell: UICollectionViewCell {

    @IBOutlet weak var lblMenu : UILabel?
    @IBOutlet weak var imgMenu : UIImageView?
    
    var model : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let model = model as? OrdersModal {
            lblMenu?.text = model.title
            self.imgMenu?.layer.borderWidth = 1.0
            self.imgMenu?.layer.borderColor = UIColor.gray.cgColor
        
            switch model.title {
                
            case "Restaurants":
                imgMenu?.image = R.image.icon_restaurants()
                
            case "Organic Products":
                 imgMenu?.image = R.image.ic_organic()
                
            case "Sweets & Bakeries":
                  imgMenu?.image = R.image.icon_sweets()
                
            case "Medicines":
                imgMenu?.image = R.image.icon_medicines()
                
            case "All Other":
                imgMenu?.image = R.image.icon_order()
                
            case "Groceries":
                imgMenu?.image = R.image.icon_grocies()
                
            case "Dairy products":
                imgMenu?.image = R.image.icon_dairy()
                
            case "Meat & Seafood":
                imgMenu?.image = R.image.icon_meant()
                
            case "Fashion":
                imgMenu?.image = R.image.icon_fashion()
                
            case "Gifts":
                imgMenu?.image = R.image.icon_gifts()
                
            case "Beauty":
                imgMenu?.image = R.image.icon_beauty()
                
            case "Fruits & Vegetables":
                imgMenu?.image = R.image.icon_fruits()
                
            case "Home Appliances":
                imgMenu?.image = R.image.icon_homeAppliances()
                
            case "Mobiles":
                imgMenu?.image = R.image.icon_mobiles()
                
            default:
                imgMenu?.image = R.image.icon_order()
            }
        }
    }
}





