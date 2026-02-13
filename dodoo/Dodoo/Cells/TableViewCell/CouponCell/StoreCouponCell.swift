//
//  StoreCouponCell.swift
//  Dodoo
//
//  Created by Banka Rajesh on 08/09/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class StoreCouponCell: UICollectionViewCell {

    @IBOutlet weak var lblDiscountUpto : UILabel?
    @IBOutlet weak var lblCouponCode: UILabel?
    @IBOutlet weak var lblAboveAmount: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var index : Int? {
        didSet {
            configure()
        }
    }
    
    var model : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let model = model as? GetOffersModal {
            lblDiscountUpto?.text = model.descriptionField
            lblCouponCode?.text = "USE \(model.couponCode ?? "")"
            lblAboveAmount.text = "ABOVE ₹\(model.MinCartAmount ?? "300")"
        }
    }

}
