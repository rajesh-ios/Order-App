//
//  StoreItemSectionHeader.swift
//  Dodoo
//
//  Created by Shubham on 02/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class StoreItemSectionHeader : UIView {

    @IBOutlet weak var lblItemCaetgory : UILabel?
    @IBOutlet weak var btnCategory : UIButton?
    
    var modal : Any?{
        didSet {
            configure()
        }
    }
    
    class func instanceFromNib() -> UIView? {
        return UINib(nibName: "StoreItemSectionHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func configure() {
        if let modal = modal as? String {
            lblItemCaetgory?.text = modal
        }
    }
    
    @IBAction func btnUpDownAct(_ sender : UIButton){
    }
}
