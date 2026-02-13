//
//  RatingViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/24/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire

class RatingViewController: BaseViewController {

    @IBOutlet weak var rateOrder: CosmosView!
    @IBOutlet weak var rateStore: CosmosView!
    @IBOutlet weak var rateDeliveryBoy: CosmosView!
    @IBOutlet weak var textVwOnStore: UITextView!
    @IBOutlet weak var textVwOnDeliveryBoy: UITextView!
    
    
    var orderModal : OrdersModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnSubmitOrderAct(_ sender: Any) {
        if rateOrder.rating != 0.0 {
            giveRatingAPI()
        }
        else {
            Messages.shared.show(alert: .oops, message: "Please give your rating on order", type: .warning)
        }
       
    }
}

extension RatingViewController {

    func giveRatingAPI() {
        let ratingModal = RatingModal(id_: /orderModal?.id, RatingToDlvryBoy_: rateDeliveryBoy.rating.toString, RatingToStore_: rateStore.rating.toString, OrderId_: /orderModal?.orderID, OrderType_: /orderModal?.orderType, CommentToDeliveryBoy_: /textVwOnDeliveryBoy?.text, CommentToStore_: /textVwOnStore?.text)
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.rateOrder(details: ratingModal.toJSON())) { response in
            self.handleResponse(response: response) { success in
                self.handleRatingSuccess(response : success)
            }
        }
    }
    
    func handleRatingSuccess(response : AnyObject?) {
        if let modal = response as? RegisterModal{
            if modal.Status == "1" {
                Messages.shared.show(alert: .success, message: "Thanks for your feedback !!", type: .success)
                self.popVC()
            }
        }
        Utility.shared.stopLoader()
    }
}

extension RatingViewController {
       
}
