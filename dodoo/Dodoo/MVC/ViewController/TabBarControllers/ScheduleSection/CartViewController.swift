//
//  CartViewController.swift
//  Dodoo
//
//  Created by Shubham on 05/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

protocol UpdateItemListDelegate: AnyObject {
    func updateItem(item : Items?)
}

class CartViewController: BaseViewController {
    
    @IBOutlet weak var lblTotalCost : UILabel?
    @IBOutlet weak var btnProceed : UIButton?
    @IBOutlet weak var lblNoItem : UILabel?
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var selectItems = [Items]()
    var storeModal : StoresModal?
    var isFirstTime : Bool = true
    var totalCost : Int = 0
    weak var delegate : UpdateItemListDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        if selectItems.count != 0 {
            reloadTable()
        }
        lblNoItem?.isHidden = self.selectItems.count != 0
        btnProceed?.alpha = self.selectItems.count == 0 ? 0.5 : 1.0
        btnProceed?.isUserInteractionEnabled = self.selectItems.count != 0
    }
    
    @IBAction func btnProceedAct(_ sender : UIButton){
//        guard let vc = R.storyboard.home.communicationAddressViewController() else {
//            return
//        }
//        vc.totalCost = self.totalCost
//        vc.storeModal = storeModal
//        vc.selectItems = self.selectItems
//        self.pushVC(vc)
        
        guard let vc = R.storyboard.main.myAddressesViewController() else {
            return
        }
        
        vc.totalCost = self.totalCost
        vc.storeModal = storeModal
        vc.selectItems = self.selectItems
        vc.forProfile = false
        self.pushVC(vc)
    }
}

extension CartViewController {
    
    func configureTableView() {
        tableDataSource = TableViewDataSource(items: selectItems, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.nib.cartItemCell.identifier)
        
        tableDataSource?.configureCellBlock = { [weak self](cell, item, indexpath) in
            
            guard let self = self else {return}
            (cell as? CartItemCell)?.indexPath = indexpath
            (cell as? CartItemCell)?.modal = item
            (cell as? CartItemCell)?.delegate = self
            
        }
    }
    
    func reloadTable() {
        tableView.register(R.nib.cartItemCell(), forCellReuseIdentifier: R.nib.cartItemCell.identifier)
        
        if isFirstTime {
            self.isFirstTime = false
            configureTableView()
        }
        else {
            tableDataSource?.items = self.selectItems
            tableView?.reloadData()
        }
        self.updateCartList()
    }
    
    
    func updateCartList() {
        totalCost = 0
        lblNoItem?.isHidden = self.selectItems.count != 0
        if self.selectItems.count == 0 {
            lblTotalCost?.text =  "₹\(totalCost)"
            btnProceed?.alpha = 0.5
            btnProceed?.isUserInteractionEnabled = false
            
            return
        }
        if self.selectItems.count != 0 {
            for (_, item) in selectItems.enumerated() {
                if item.quantity == 0 {
                    continue
                }
                else {
                    totalCost = totalCost + (item.quantity * /item.UnitPrice?.toInt())
                }
            }
        }
        lblTotalCost?.text =  "₹\(totalCost)"
        btnProceed?.alpha = self.totalCost == 0 ? 0.5 : 1.0
        btnProceed?.isUserInteractionEnabled = self.totalCost != 0
    }
}


extension CartViewController : DeleteCartItemDelegate{
    
    func deleteItem(index: Int? , forDelete : Bool?) {
        
        if /forDelete {
            if let index = index {
                if index < self.selectItems.count {
                    self.selectItems[index].quantity = 0
                    delegate?.updateItem(item: self.selectItems[index])
                    self.selectItems.remove(at: index)
                    self.reloadTable()
                }
            }
        }
            
        else {
            if let index = index {
                if index < self.selectItems.count {
                    let selectItem = self.selectItems[index]
                    delegate?.updateItem(item: selectItem)
                }
            }
        }
    }
}
