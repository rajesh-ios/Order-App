//
//  CouponCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/7/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
protocol SelectItemDelegate: AnyObject {

    func selectItem(tag : Int)
    
}

class CouponCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var lblDesc : UILabel?
    @IBOutlet weak var btnSelect : UIButton?
    
    var index : Int?
    weak var delegate : SelectItemDelegate?
    var model : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let model = model as? GetOffersModal {
            lblDesc?.text = model.descriptionField
            lblTitle?.text = model.couponCode
        }
    }
    
    
    @IBAction func btnSelectCouoonAct(_ sender : UIButton){
        delegate?.selectItem(tag : sender.tag)
    }
}
