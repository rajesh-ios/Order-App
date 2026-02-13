//
//  CouponViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/7/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

protocol SelectCouponDelegate: AnyObject {
    func selectCoupon(coupon : GetOffersModal)
}

class CouponViewController: BaseViewController {

    var coupons = [GetOffersModal]()
    
    var isFirstTime : Bool = true
    weak var delegate : SelectCouponDelegate?
    weak var itemDelegate : SelectItemDelegate?
    var cartAmount: Int?
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTable()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillLayoutSubviews() {
        
        tableViewHeight.constant = self.tableView.contentSize.height - CGFloat((coupons.count * 25))
    }
}


extension CouponViewController {
    
    func configureTableView() {
        tableDataSource = TableViewDataSource(items: self.coupons, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.nib.couponCell.identifier)
        
        tableDataSource?.configureCellBlock = {[weak self](cell, item, indexpath) in
            
            guard let self = self else { return }
            (cell as? CouponCell)?.btnSelect?.tag = /indexpath?.row
            (cell as? CouponCell)?.model = item
            (cell as? CouponCell)?.delegate = self
            
        }
        
        tableDataSource?.aRowSelectedListener = {[weak self](indexpath,cell) in
            
            guard let self = self else { return }
            self.selectItem(tag: indexpath.row)
        }
    }
    
    func reloadTable() {
        tableView.register(R.nib.couponCell(), forCellReuseIdentifier: R.nib.couponCell.identifier)
        
        if isFirstTime {
            self.isFirstTime = false
            configureTableView()
        }
        else {
            tableDataSource?.items = self.coupons
            tableView?.reloadData()
        }
    }
}


extension CouponViewController: SelectItemDelegate {
    func selectItem(tag: Int) {
        if tag < self.coupons.count {
            let selectedCoupon = self.coupons[tag]
            
            if let cartAmount = cartAmount {
                
                if cartAmount >= (selectedCoupon.MinCartAmount?.toInt())! {
                    
                    delegate?.selectCoupon(coupon: selectedCoupon)
                    self.dismissVC(completion: nil)
                }
                else {
                    Messages.shared.show(alert: .oops, message: kminimumCartValueCouponError.replace(target: "@", withString: "\(selectedCoupon.MinCartAmount ?? "")"), type: .warning)
                }
            }
            
        }
    }
}
