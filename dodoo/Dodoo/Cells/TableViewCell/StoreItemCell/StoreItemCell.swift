//
//  StoreItemCell.swift
//  Dodoo
//
//  Created by Shubham on 02/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

class StoreItemCell: TableParentCell {

    @IBOutlet weak var lblItemName : UILabel?
    @IBOutlet weak var imgVeg : UIImageView?
    @IBOutlet weak var btnMinus : UIButton?
    @IBOutlet weak var btnPlus : UIButton?
    @IBOutlet weak var lblItemCost : UILabel?
    @IBOutlet weak var lblQuantity : UILabel?

  
    var indexPath : IndexPath?
    
    override func configure() {
        if let modal = modal as? Items {
            lblItemName?.text = modal.ItemName
            imgVeg?.image = modal.DishType?.lowercased().trimmed() == "veg" ? R.image.veg() : R.image.non_veg()
            lblQuantity?.text = modal.quantity.toString
            lblItemCost?.text = R.string.localize.price(/modal.UnitPrice)
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
    
    func updateModal() {
        if ez.topMostVC is StoreItemViewController , let indexPath = indexPath{
            let categoryNo = indexPath.section
            let itemNo = indexPath.row
            if let modal = modal as? Items {
                (ez.topMostVC as? StoreItemViewController)?.categoriesWithItemArr[categoryNo].items?[itemNo] = modal
                (ez.topMostVC as? StoreItemViewController)?.reloadTable()
                
                
            }
        }
    }
}
