
//
//  OrderStatusCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 8/18/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class OrderStatusCell: UICollectionViewCell {
    @IBOutlet weak var linearView : UIView?
    @IBOutlet weak var btnItem : UIButton?
    
    
    var model : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let model = model as? String {
            btnItem?.setTitle(model, for: .normal)
        }
    }
}
