//
//  WhatsAppManager.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 9/25/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit

class WhatsAppManager : NSObject {
    
    
    static let shared = WhatsAppManager()
    
    func openWhatsapp(phoneNo : String? = APIConstants.whatsAppBusinessAcccountNo){
        
        var message = "Hi DoDoo,"
        
        if let userDetails = UDKeys.UserDTL.fetch() as? UserDetails, let usrName = userDetails.name {
            
            message = message + "\r\nMy Name is \(usrName),"
        }
        
        if let usrLocation = UDKeys.UsedCity.fetch() {
            
            message = message + "\r\nI'm looking for service in \(usrLocation)"
            print(message)
        }
        
        let urlWhats = "whatsapp://send?phone=\(/phoneNo)&text=\(/message)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
//        if let url = URL(string: "https://wa.me?\(/phoneNo)&text=\(/message)") {
//                UIApplication.shared.open(url, options: [:])
//        }
    }
    
    func openWhatsappStoreItem(phoneNo : String? = APIConstants.whatsAppBusinessAcccountNo){
        
        var message = "Hi DoDoo,"
        
        let urlWhats = "whatsapp://send?phone=\(/phoneNo)&text=\(/message)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
}
