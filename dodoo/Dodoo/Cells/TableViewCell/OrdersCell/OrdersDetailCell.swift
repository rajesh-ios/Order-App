
//
//  OrdersDetailCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/11/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class OrdersDetailCell: UITableViewCell {

    @IBOutlet weak var lbldesc : UILabel?
    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var lblQty : UILabel?
    @IBOutlet weak var lblPrice : UILabel?
    @IBOutlet weak var lblPriceName: UILabel!
    @IBOutlet weak var lblQuantityName: UILabel!
    
    
    var modal : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let modal = modal as? CartItem {
            
            if modal.qty == "Subscription" {
                
                lblPriceName.text = "Delivery Cycle"
                lblQuantityName.text = "Order Type"
                lblPrice?.text = /modal.price
                lbldesc?.text =  /modal.desc
                lblQty?.text = /modal.qty
                lblTitle?.text = /modal.title
            }
            else if modal.qty == "Pickup Drop" {
                
                lblQuantityName.text = "Order Type"
                lbldesc?.text =  /modal.desc
                lblQty?.text = /modal.qty
                lblPrice?.text = "₹ \(/modal.price)"
                lblTitle?.text = /modal.title
            }
            else {
                
                lbldesc?.text =  /modal.desc
                lblQty?.text = /modal.qty
                lblPrice?.text = "₹ \(/modal.price)"
                lblTitle?.text = /modal.title
            }
            
        }
    }
}
