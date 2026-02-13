//
//  OrderDetailsViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/10/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

class OrderDetailsViewController: BaseViewController {
    
    var orderId : String?
    var orderDetails : [OrderDetailModal]?
    var cartItemArr : [CartItem]?
    var isFirstTime : Bool = true
    
    @IBOutlet weak var lblOrderID : UILabel?
    @IBOutlet weak var lblStoreName : UILabel?
    @IBOutlet weak var lblOrderDate : UILabel?
    @IBOutlet weak var lblOrderTotal : UILabel?
    @IBOutlet weak var lblPaymentMethod : UILabel?
    @IBOutlet weak var tblViewHeight : NSLayoutConstraint?
    @IBOutlet weak var lblName : UILabel?
    @IBOutlet weak var lblAddress : UILabel?
    @IBOutlet weak var lblPhoneNo : UILabel?
    @IBOutlet weak var lblItemTotal : UILabel?
    @IBOutlet weak var lblTotal: UILabel?
    
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblConvenienceCharge: UILabel!
    @IBOutlet weak var lblPromotionCode: UILabel!
    @IBOutlet weak var lblWalletAmount: UILabel!
    @IBOutlet weak var lblTotalOrder: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var headerHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var storeNameView: UIView!
    @IBOutlet weak var orderSummaryView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeightConstraints.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        lblOrderID?.text = /orderId
        getOrderDetails()
    }
    
}


//API
extension OrderDetailsViewController {
    
    func getOrderDetails() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: LoginEndpoint.getOrderDetails(orderID: self.orderId)) {[weak self] (response) in
            self?.handleResponse(response: response, responseBack: { (success) in
                self?.handle(response : success)
            })
        }
    }
    
    func handle(response : Any?){
        if let modal = response as? [OrderDetailModal] {
            print(modal.count)
            self.orderDetails = modal
            setUpDetails()
        }
    }
    
    func setUpDetails() {
        if let orderDTL = self.orderDetails?.first {
            
            if orderDTL.orderID?.contains("STOR") ?? false {
                
                lblStoreName?.text = /orderDTL.storeID
                lblName?.text = /orderDTL.name
                lblAddress?.text = /orderDTL.dropAddress
                lblPhoneNo?.text = /orderDTL.contactNo
            }
            else if orderDTL.orderID?.contains("SB") ?? false
            {
                lblPaymentMethod?.text = "Cash On Delivery"
                lblStatus.text = "\(/orderDTL.status)"
                lblAddress?.text = "\(/orderDTL.Address)"
                lblName?.text = /orderDTL.Name
                lblPhoneNo?.text = /orderDTL.ContactNo
                storeNameView.removeFromSuperview()
                orderSummaryView.removeFromSuperview()
            }
            else {
                
                lblAddress?.text = "\(/orderDTL.landMarkDropAddress)"
                lblName?.text = /orderDTL.Name
                lblPhoneNo?.text = /orderDTL.ContactNo
                storeNameView.removeFromSuperview()
            }
            
            lblOrderDate?.text = /orderDTL.orderDate
            if orderDTL.totPrice != "" {
                lblOrderTotal?.text = "₹ \(/orderDTL.totPrice)"
                
                if orderDTL.orderID?.contains("PDP") ?? false {
                    
                    lblItemPrice?.text = "₹ \(/orderDTL.totPrice)"
                }
                else {
                    
                    lblItemPrice?.text = "₹ \(/orderDTL.price)"
                }
                
                lblTotal?.text = "₹ 0.00"
                lblItemTotal?.text = "₹ \(/orderDTL.totPrice)"
                
                if let paymentMode = orderDTL.paymentMode {
                    lblPaymentMethod?.text = paymentMode
                }
                else {
                    lblPaymentMethod?.text = "Cash On Delivery"
                }
                
                lblServiceCharge.text = "₹ \(/orderDTL.DeliveryCharge)"
                lblConvenienceCharge.text = "₹ \(/orderDTL.Tax)"
                
                if orderDTL.WalletAmount == "" {
                    
                    lblWalletAmount.text = "-₹ 0.0"
                }
                else {
                    
                    lblWalletAmount.text = "-₹ \(/orderDTL.WalletAmount)"
                }
                
                if orderDTL.PromoCode == "" {
                    
                    lblPromotionCode.text = "--"
                }
                else {
                    
                    lblPromotionCode.text = "\(/orderDTL.PromoCode)"
                }
                
                lblTotal?.text = "₹ \(/orderDTL.totPrice)"
                lblTotalOrder?.text = "₹ \(/orderDTL.totPrice)"
                lblStatus.text = "\(/orderDTL.status)"
            }
            else {
                lblOrderTotal?.text = "--"
                lblItemPrice?.text = ""
                lblTotal?.text = ""
                lblItemTotal?.text = ""
            }
            
            self.tableView.isScrollEnabled = false
            
            if let cartItems = orderDTL.cartItems {
                
                if cartItems.count == 0 {
                    
                    if orderDTL.orderID?.contains("SB") ?? false {
                        
                        let cartItem = CartItem(Title_: orderDTL.title, Desc_: orderDTL.desc, Price_: orderDTL.DelvryCycle, Qty_: "Subscription")
                        
                        self.cartItemArr = [cartItem]
                        ez.runThisInMainThread {
                            self.tblViewHeight?.constant = 104
                            self.reloadTable()
                        }
                    }
                    else {
                        
                        let cartItem = CartItem(Title_: orderDTL.title, Desc_: orderDTL.desc, Price_: orderDTL.totPrice, Qty_: "Pickup Drop")
                        
                        self.cartItemArr = [cartItem]
                        ez.runThisInMainThread {
                            self.tblViewHeight?.constant = 104
                            self.reloadTable()
                        }
                    }
                    
                }
                else {
                    
                    self.cartItemArr = cartItems
                    ez.runThisInMainThread {
                        self.tblViewHeight?.constant = CGFloat(/self.cartItemArr?.count  * 110 - (6 * cartItems.count))
                        self.tableView.isScrollEnabled = false
                        self.reloadTable()
                    }
                }
            }
        }
        Utility.shared.stopLoader()
    }
}

extension OrderDetailsViewController {
    
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: cartItemArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.reuseIdentifier.ordersDetailCell.identifier)
        
        tableDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? OrdersDetailCell)?.modal = item
        }
    }
    
    func reloadTable() {
        if isFirstTime {
            self.isFirstTime = false
            configureTableView()
        }
        else {
            tableDataSource?.items = self.cartItemArr
            tableView?.reloadData()
        }
    }
}
