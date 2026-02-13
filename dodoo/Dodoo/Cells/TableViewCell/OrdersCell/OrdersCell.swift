//
//  OrdersCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/9/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
protocol OrderActionDelegate {
    func rateOrderAct(tag : Int)
    func trackOrderAct(tag : Int)
    func cancelOrderAct(tag : Int)
}
class OrdersCell: UITableViewCell {
 
    @IBOutlet weak var lblOrderNo : UILabel?
    @IBOutlet weak var btnTrackOrder : UIButton?
    @IBOutlet weak var btnRateOrder : UIButton?
    @IBOutlet weak var btnCancelOrder : UIButton?
    @IBOutlet weak var lblStatus : UILabel?
    @IBOutlet weak var lblItemValue : UILabel?
    @IBOutlet weak var lblItemKey : UILabel?

    var index : Int?
    var selectTab : Int?
    var delegate : OrderActionDelegate?
    var model : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let model = model as? OrdersModal {
            lblOrderNo?.text = model.orderID
            
            lblStatus?.text = model.status
            btnRateOrder?.isHidden = (model.status == "Open")
            btnCancelOrder?.isHidden = !(self.selectTab == 0)
            btnTrackOrder?.isHidden = !(/btnRateOrder?.isHidden)
            
            if  model.totalPrice?.trimmed().count != 0{
                lblItemKey?.text =  "Total Price"
                lblItemValue?.text = "₹ \(/model.totalPrice)"
            }
            else {
                lblItemKey?.text =  "Order Type"
                lblItemValue?.text = model.orderType
            }
            }
        if let index = index {
            btnRateOrder?.tag  = index
            btnRateOrder?.tag = index
            btnCancelOrder?.tag = index
        }
    }
   
    @IBAction func btnTrackOrderAct(_ sender : UIButton){
        delegate?.trackOrderAct(tag: sender.tag)
    }
    
    
    @IBAction func btnRateOrderAct(_ sender : UIButton){
        delegate?.rateOrderAct(tag: sender.tag)
    }
    
    @IBAction func btnCancelOrderAct(_ sender : UIButton){
        delegate?.cancelOrderAct(tag: sender.tag)
    }
    
    }
    


