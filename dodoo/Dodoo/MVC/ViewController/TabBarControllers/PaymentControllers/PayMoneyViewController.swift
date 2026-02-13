//
//  PayMoneyViewController.swift
//  Dodoo
//
//  Created by Shubham on 06/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
import Razorpay

class PayMoneyViewController: BaseViewController {

    var razorpay: RazorpayCheckout?
    var totalPrice : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = RazorpayCheckout.initWithKey(APIConstants.RAZORPAY_DEV_KEY, andDelegate: self)
//        razorpay = Razorpay.initWithKey(APIConstants.RAZORPAY_DEV_KEY, andDelegate: self)
        showPaymentForm()
    }
    
    
    internal func showPaymentForm(){
        
        guard let userDTL = UDKeys.UserDTL.fetch() as? UserDetails else{
        print("userDetails is nil")
            return
        }
    
        let options: [String:Any] = [
            "amount" : "\(/totalPrice)",
            "description": "",
            "image": "https://url-to-image.png",
            "name": "\(/userDTL.name)",
            "prefill": [
            "contact": "\(/userDTL.mobno)",
            "email": "\(/userDTL.email)",
            ],
            "theme": [
                "color": "#C0CF2C"
            ]
        ]
        if let rzp = self.razorpay {
            rzp.open(options)
        } else {
            print("Unable to initialize")
        }
    }
    
    
}


extension PayMoneyViewController : RazorpayPaymentCompletionProtocol {
    
    public func onPaymentError(_ code: Int32, description str: String){
        let alertController = UIAlertController(title: "Failure", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func onPaymentSuccess(_ payment_id: String){
        let alertController = UIAlertController(title: "Success", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
