//
//  CashfreeModal.swift
//  Dodoo
//
//  Created by Apple on 22/11/21.
//  Copyright © 2021 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

/*CASHFREE SUCCESS RESPONSE */
//{"orderId":"800","referenceId":"1170995","orderAmount":"150.00","txStatus":"SUCCESS","txMsg":"Transaction Successful","txTime":"2021-11-21 23:42:33","paymentMode":"Wallet","signature":"9FmWF5M+2nG5IbGzqFAd9XNWBrMx38WlfsWhxrXKtq4="}

/*CASHFREE FAILURE RESPONSE */

//{"orderId":"850","referenceId":"1170996","orderAmount":"200.00","txStatus":"FAILED","txMsg":"Your transaction has failed.","txTime":"2021-11-21 23:46:44","paymentMode":"Wallet","signature":"RTwe0quzZg57MHdgPMTma3l5deqse95Gu7P4qBhli+8="}

class CashfreeModal : Mappable {
    
    var orderId : String?
    var referenceId : String?
    var orderAmount : String?
    var txStatus : String?
    var txMsg : String?
    var txTime : String?
    var paymentMode : String?
    var signature : String?
     
    init (orderId : String? , referenceId : String?, orderAmount : String? , txStatus : String? ,txTime : String? , txMsg : String? , paymentMode : String? , signature : String?) {
        
        self.orderId = orderId
        self.referenceId = referenceId
        self.orderAmount = orderAmount
        self.txStatus = txStatus
        self.txTime = txTime
        self.txMsg = txMsg
        self.paymentMode = paymentMode
        self.signature = signature
    
    }
    
    required init?(map: Map) {
        
        orderId <- map["orderId"]
        referenceId <- map["referenceId"]
        orderAmount <- map["orderAmount"]
        txStatus <- map["txStatus"]
        txTime <- map["txTime"]
        txMsg <- map["txMsg"]
        paymentMode <- map["paymentMode"]
        signature <- map["signature"]

    }
    
    func mapping(map: Map) {
        
        orderId <- map["orderId"]
        referenceId <- map["referenceId"]
        orderAmount <- map["orderAmount"]
        txStatus <- map["txStatus"]
        txTime <- map["txTime"]
        txMsg <- map["txMsg"]
        paymentMode <- map["paymentMode"]
        signature <- map["signature"]
        
    }
    
    init(json : JSON) {
        orderId = json["orderId"].stringValue
        referenceId = json["referenceId"].stringValue
        orderAmount = json["orderAmount"].stringValue
        txStatus = json["txStatus"].stringValue
        txTime = json["txTime"].stringValue
        txMsg = json["txMsg"].stringValue
        paymentMode = json["paymentMode"].stringValue
        signature = json["signature"].stringValue
    }
    
}

