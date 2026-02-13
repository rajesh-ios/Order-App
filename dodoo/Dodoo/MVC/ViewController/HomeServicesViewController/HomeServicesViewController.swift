//
//  HomeServicesViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 9/26/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class HomeServicesViewController: BaseViewController {

    @IBOutlet weak var btnWhataspp : UIButton?
    @IBOutlet weak var brnLater : UIButton?
    @IBOutlet weak var btnCall : UIButton?
    

    @IBAction func btnWhatsAppAct(_ sender : UIButton){
        WhatsAppManager.shared.openWhatsapp()
    }
    
    @IBAction func btnCallAct(_ sender : UIButton){
        numberToCall(phoneNumber: APIConstants.whatsAppBusinessAcccountNo)
    }
    
    func numberToCall(phoneNumber : String?){
           if let phoneNo = phoneNumber {
               if let url = URL(string: "tel://\(phoneNo)") {
                   if #available(iOS 10, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   } else {
                       UIApplication.shared.openURL(url as URL)
                   }
                   }
           }
       }
}
