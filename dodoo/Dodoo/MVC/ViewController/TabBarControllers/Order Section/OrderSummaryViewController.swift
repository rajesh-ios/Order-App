//
//  OrderSummaryViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/17/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class OrderSummaryViewController : BaseViewController {
    
    @IBOutlet weak var lblStatusOrderConfirmation : UILabel?
    @IBOutlet weak var lblStatusOrderPickUp : UILabel?
    @IBOutlet weak var lblStatusOntheWay : UILabel?
    @IBOutlet weak var lblStatusDelivered : UILabel?
    
    
    @IBOutlet weak var imgOrderConfirmation : UIImageView?
    @IBOutlet weak var imgOrderPickUp : UIImageView?
    @IBOutlet weak var imgOnTheWay : UIImageView?
    @IBOutlet weak var imgOrderDelivered : UIImageView?
    
    
    @IBOutlet weak var lblOrderConfirmHeading : UILabel?
    @IBOutlet weak var lblOrderPickUpHeading : UILabel?
    @IBOutlet weak var lblOrderOnTheWayHeading : UILabel?
    @IBOutlet weak var lblOrderDeliveredHeading : UILabel?
    
    @IBOutlet weak var lblOrderConfirDesc : UILabel?
    @IBOutlet weak var lblOrderPickUpDesc : UILabel?
    @IBOutlet weak var lblOrderOnTheWayDesc : UILabel?
    @IBOutlet weak var lblOrderDeliveredDesc : UILabel?
    
    @IBOutlet weak var btnBack : UIButton?
    
    @IBOutlet weak var lblEstimatedTime : UILabel?
    @IBOutlet weak var lblStoreId : UILabel?
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    
    var orderStatus : String?
    var orderModal : OrdersModal?
    var storeModal : StoresModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightConstraints.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
//        if let deliveryTime = storeModal?.DeliveryTime {
            
            // change suggest by pradeep on 13th Oct to hardcode it
//            lblEstimatedTime?.text = "15 mins to 35 mins"
            lblEstimatedTime?.text = "\(Int.random(in: 20...30)) mins"
//        }

        lblStoreId?.text = orderModal?.orderID
        getOrderStatus()
        btnBack?.isHidden = /self.navigationController?.viewControllers.count > 2
    }
    
    @IBAction func  btnCancelOrderAct(_ sender : UIButton){
        cancelOrderConfirmation()
    }
    
    @IBAction func  btnBackToHomeAct(_ sender : UIButton){
        navigateToRootVc()
    }
    
}

extension OrderSummaryViewController {
    func navigateToRootVc() {
        guard let viewControllers = self.navigationController?.viewControllers else {
            return
        }
        _ = viewControllers.map({ viewController in
            if viewController is TabBarController {
                (viewController as? TabBarController)?.selectedIndex = 0
                self.navigationController?.popToViewController(viewController, animated: false)
            }
        })
    }
    
    func cancelOrderConfirmation() {
        AlertsClass.shared.showAlertController(withTitle: R.string.localize.attention(), message: R.string.localize.cancelOrderConfirmation() ,buttonTitles : [R.string.localize.ok(),R.string.localize.cancel()]) {(value) in
            let type = value as AlertTag
            switch type {
            case .yes:
               self.cancelOrder()
            default : return
            }
        }
    }
}


extension OrderSummaryViewController {
    
    func cancelOrder() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.updateOrderStatus(OrderType: orderModal?.orderType, OrderStatus: "Cancel", OrderID: orderModal?.orderID)) { [weak self](response) in
            self?.handle(response : response)
        }
    }
    
    func handle(response : Response){
        switch response {
        case .success(let obj):
            
            //REPONSE FOR CANCEL ORDER
            if let modal = obj as? RegisterModal {
                
                if modal.Result == "Update Success" && modal.Status == "1" {
                    Messages.shared.show(alert: .success, message: R.string.localize.orderCancelSuccess(), type: .success)
                    if storeModal != nil {
                        navigateToRootVc()
                    }
                    else {
                    popVC()
                    }
                }
                else {
                    Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
                }
            }
            
            //RESPONSE FOR GET ORDER STATUS
            if let modal = obj as? [OrderDetailModal] , let orderDTL = modal.first ,let staus = orderDTL.status{
                self.orderStatus = staus
                UIView.animate(withDuration: 5.0) {
                    self.updateUI()
                }
                
            }
            
        default:
            break
        }
        Utility.shared.stopLoader()
    }
}


extension OrderSummaryViewController {
    
    func getOrderStatus() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: LoginEndpoint.getOrderDetails(orderID : orderModal?.orderID) , isLoader : true) { [weak self](response) in
            self?.handle(response: response)
        }
    }
    
    
    //Upate UI according to the order Status
    func updateUI() {
        
        guard let orderStatus = self.orderStatus else {
            print("Order status is nil please check the parameter in the api")
            return
        }
        
        switch orderStatus {
        case "Open":
            selectState(labelObj: lblStatusOrderConfirmation, labelHeadingObj: lblOrderConfirmHeading, labelDescObj: lblOrderConfirDesc, image: R.image.orderConfirmation(), imgObj: imgOrderConfirmation, selectState: 1)
            
            
            
            break
            
        case "Accept":
            selectState(labelObj: lblStatusOrderPickUp, labelHeadingObj: lblOrderPickUpHeading, labelDescObj: lblOrderPickUpDesc, image: R.image.orderPickup(), imgObj: imgOrderPickUp, selectState: 1)
            
            break
            
        case "InProgress":
            selectState(labelObj: lblStatusOrderPickUp, labelHeadingObj: lblOrderPickUpHeading, labelDescObj: lblOrderPickUpDesc, image: R.image.orderPickup(), imgObj: imgOrderPickUp, selectState: 1)
            
            selectState(labelObj: lblStatusOntheWay, labelHeadingObj: lblOrderOnTheWayHeading, labelDescObj: lblOrderOnTheWayDesc, image: R.image.onTheWay(), imgObj: imgOnTheWay, selectState: 1)
            
            break
            
        case "Deliver":
            
            selectState(labelObj: lblStatusOrderPickUp, labelHeadingObj: lblOrderPickUpHeading, labelDescObj: lblOrderPickUpDesc, image: R.image.orderPickup(), imgObj: imgOrderPickUp, selectState: 1)
            
            selectState(labelObj: lblStatusOntheWay, labelHeadingObj: lblOrderOnTheWayHeading, labelDescObj: lblOrderOnTheWayDesc, image: R.image.onTheWay(), imgObj: imgOnTheWay, selectState: 1)
            
            selectState(labelObj: lblStatusDelivered, labelHeadingObj: lblOrderDeliveredHeading, labelDescObj: lblOrderDeliveredDesc, image: R.image.orderDelivered(), imgObj: imgOrderDelivered, selectState: 1)
            break
            
        default:
            break
        }
        
    }
    
    
    func selectState(labelObj : UILabel?  , labelHeadingObj : UILabel? , labelDescObj : UILabel? , image : UIImage? , imgObj : UIImageView? , selectState : Int) {
        
        if selectState == 1 {
            labelObj?.backgroundColor = UIColor.ColorApp
            imgObj?.image = image
            labelHeadingObj?.textColor = UIColor.ColorGrey
        }
    }
}
