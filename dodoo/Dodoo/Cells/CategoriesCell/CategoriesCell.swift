//
//  CategoriesCell.swift
//  Dodoo
//
//  Created by Shubham on 25/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class CategoriesCell : UICollectionViewCell {
    
    @IBOutlet weak var btnCategory : UIButton?
    
    var modal : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        if let modal = modal as? OrdersModal {
            btnCategory?.setTitle(modal.title, for: .normal)
            btnCategory?.isUserInteractionEnabled = false
            btnCategory?.setBackgroundColor(modal.isSelected ? UIColor.ColorApp : UIColor.white, forState: .normal)
        }
    }
}
