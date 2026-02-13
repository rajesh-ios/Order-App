//
//  CartItemCell.swift
//  Dodoo
//
//  Created by Shubham on 05/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

protocol DeleteCartItemDelegate: AnyObject {
    func deleteItem(index : Int?, forDelete : Bool?)
}
class CartItemCell: TableParentCell {

    @IBOutlet weak var lblItemName : UILabel?
    @IBOutlet weak var imgVeg : UIImageView?
    @IBOutlet weak var btnMinus : UIButton?
    @IBOutlet weak var btnPlus : UIButton?
    @IBOutlet weak var lblItemCost : UILabel?
    @IBOutlet weak var lblQuantity : UILabel?
    @IBOutlet weak var btnDeleteItem : UIButton?
    
    
    var indexPath : IndexPath?
    weak var delegate : DeleteCartItemDelegate?
    
    override func configure() {
        if let modal = modal as? Items {
            lblItemName?.text = modal.ItemName
            imgVeg?.image = modal.DishType?.lowercased().trimmed() == "veg" ? R.image.veg() : R.image.non_veg()
            lblQuantity?.text = modal.quantity.toString
            lblItemCost?.text = R.string.localize.price(/modal.UnitPrice)
            btnDeleteItem?.tag = /indexPath?.row
            
        }
    }
    
    
    @IBAction func btnQuantityAct(_ sender : UIButton){
        
        if let modal = modal as? Items {
            
            //Decrease quantity
            if sender.tag == 0 {
                if modal.quantity != 0 {
                    modal.quantity = modal.quantity - 1
                }
            }
                
                //Increase Quantity
            else {
                modal.quantity = modal.quantity + 1
            }
            updateModal()
        }
        
    }
    
    
    @IBAction func btnDeleteCartAct(_ sender : UIButton){
        if delegate != nil {
            delegate?.deleteItem(index: sender.tag ,forDelete : true)
        }
    }
    
    func updateModal() {
        if ez.topMostVC is CartViewController , let indexPath = indexPath{
            let itemNo = indexPath.row
            if let modal = modal as? Items {
                (ez.topMostVC as? CartViewController)?.selectItems[itemNo] = modal
                delegate?.deleteItem(index: itemNo ,forDelete : modal.quantity == 0)
                (ez.topMostVC as? CartViewController)?.reloadTable()
            }
        }
    }
}

