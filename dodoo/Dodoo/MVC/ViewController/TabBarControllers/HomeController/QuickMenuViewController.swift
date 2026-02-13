//
//  QuickMenuViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 4/3/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class QuickMenuViewController: BaseViewController {

    var isFirstTime : Bool = false
    var categoriesArr : [OrdersModal]? {
        didSet {
            collectionView.register(R.nib.quickMenuCell)
//            reloadCollection()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

