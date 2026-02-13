//
//  OrderViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/6/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class OrderViewController: BaseViewController {

    @IBOutlet weak var lblNoData : UILabel?
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    
    var ordersArr : [OrdersModal]?
    var selectTab : Int = 0
    var status : [String]?
    var orderStatus : [String] = ["Ongoing" ,"Completed" , "Cancel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(faButton)
//        heightConstraints.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCollection()
        getOrders()
    }
}

// MARK --------: Code of Advertisement Cell Collection :---------
extension OrderViewController {
    
    func configureCollectionView(){
        
        collectionDataSource = CollectionViewDataSource(items: orderStatus, collectionView: collectionView, cellIdentifier: R.reuseIdentifier.orderStatusCell.identifier, headerIdentifier: nil, cellHeight:  self.collectionView.frame.height, cellWidth: self.collectionView.frame.width / 3)
        
        collectionDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? OrderStatusCell)?.model = item
            (cell as? OrderStatusCell)?.linearView?.backgroundColor = self.selectTab == indexpath?.row ? UIColor.black : UIColor.clear
//            (cell as? OrderStatusCell)?.index  = indexpath?.row
        }
        
        collectionDataSource?.aRowSelectedListener = {[weak self](indexpath , cell) in
            
            guard let self = self else { return }

            if self.selectTab != indexpath.row {
                
                self.selectTab = indexpath.row
                self.reloadCollection()
                self.getOrders()
            }
            else {
                
                self.selectTab = indexpath.row
            }
        }
    }
    
    func reloadCollection() {
        configureCollectionView()
    }
}


extension OrderViewController {
    
    
    func getOrders() {
        Utility.shared.startLoader()
        switch  selectTab {
        case 0:
            status = ["Open","InProgress","Accept"]
        case 1:
            status = ["Deliver"]
        case 2:
            status = ["Cancel"]
        default:
            status = ["Open","InProgress","Accept"]
        }
        
        ordersArr?.removeAll()
        
        guard let status = status else { return }
        
        let group = DispatchGroup()
        
        var isLoader: Bool = true
        
        for i in status {
            
            group.enter()
            APIManager.shared.request(with: LoginEndpoint.allOrders(userID: self.UserID, status: i), isLoader : isLoader) {[weak self] (response) in
                
                guard let self = self else { return }

                self.handleResponse(response: response, responseBack: { (success) in
                    self.handle(response : success)
                    group.leave()
                })
            }
            isLoader = false
        }
        
        group.notify(queue: .main) {
            
            
        }
        
    }
    
    func handle(response : Any?){
        if let modal = response as? [OrdersModal] {
            
            if let _ = self.ordersArr {
                
                self.ordersArr?.append(contentsOf: modal)
            }
            else {
                
                self.ordersArr = modal
            }
            
            self.lblNoData?.isHidden = !(self.ordersArr?.count == 0)
            
            if let orderArray = ordersArr {
                
                self.ordersArr = sort(ordersModal: orderArray)
            }
            
            self.configureTableView()
            Utility.shared.stopLoader()
        }
        
        //REPONSE FOR CANCEL ORDER
        if let modal = response as? RegisterModal {
            
            if modal.Result == "Update Success" && modal.Status == "1" {
                Messages.shared.show(alert: .success, message: R.string.localize.orderCancelSuccess(), type: .success)
                Utility.shared.stopLoader()
                getOrders()
            }
            else {
                Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
            }
        }
        
        Utility.shared.stopLoader()
    }
}


extension OrderViewController {
    
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: ordersArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.reuseIdentifier.ordersCell.identifier)
       
        tableDataSource?.configureCellBlock = {[weak self](cell, item, indexpath) in
            
            guard let self = self else { return }
            
            (cell as? OrdersCell)?.delegate = self
            (cell as? OrdersCell)?.selectTab = self.selectTab
            (cell as? OrdersCell)?.index = indexpath?.row
            (cell as? OrdersCell)?.model = item
        }
        
        tableDataSource?.aRowSelectedListener = {[weak self](indexpath,cell) in
            guard let self = self else { return }

            self.didSelect(indexpath.row)
        }
    }
    
    func reloadTable() {
        configureTableView()
    }
    
    func didSelect(_ index : Int?) {
        if let index = index {
            guard let vc = R.storyboard.main.orderDetailsViewController() else {
                return
            }
            vc.orderId = self.ordersArr?[index].orderID
            self.pushVC(vc)
        }
    }
}

extension  OrderViewController : OrderActionDelegate{
    func cancelOrderAct(tag: Int) {
        guard let order = self.ordersArr?[tag] else {
                   return
        }
        cancelOrder(orderType: order.orderType , orderId: order.orderID)
    }
    
    
    func trackOrderAct(tag : Int) {
        
        guard let order = self.ordersArr?[tag] else {
            return
        }
        
        guard let orderSummaryVc = R.storyboard.home.orderSummaryViewController() else {
            return
        }
        orderSummaryVc.orderModal = order
        self.pushVC(orderSummaryVc)
    }
    
    func rateOrderAct(tag : Int){
        guard let order = self.ordersArr?[tag] else {
            return
        }
        
        guard let ratingVc = R.storyboard.main.ratingViewController() else {
            return
        }
        ratingVc.orderModal = order
        self.pushVC(ratingVc)
    }
    
    
}

extension OrderViewController {
    
    func cancelOrder(orderType : String? , orderId : String?) {
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.updateOrderStatus(OrderType: orderType, OrderStatus: "Cancel", OrderID: orderId)) { [weak self](response) in
            
            guard let strongSelf = self else { return }

            strongSelf.handleResponse(response: response, responseBack: { [weak self](success) in
                guard let self = self else { return }

                 self.handle(response : success)
            })
        }
    }
}

extension OrderViewController {
    
    func sort(ordersModal: [OrdersModal]) -> [OrdersModal] {
            
        let ascendingOrder = ordersModal.sorted(by: { $0.orderDate!.compare($1.orderDate!) == .orderedDescending })

        return ascendingOrder
    }
}
