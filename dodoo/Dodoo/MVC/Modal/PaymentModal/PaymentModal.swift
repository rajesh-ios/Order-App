//
//  PaymentModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/19/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper


class PaymentModal : Mappable {

    var eRRORCode : String?
    var orderID : String?
    var orderType : String?
    var paymentID : String?
    var paymentStatus : String?
    var transDate : String?
    var paymentMode : String?
    var paymentGateWay : String?

    init(orderID_ : String?, orderType_ : String?, paymentID_ : String?, paymentStatus_ : String?, errorCode_ : String? , transDate_ : String?  , PaymentGateWay_ : String? , paymentMode_ : String?) {
        eRRORCode = errorCode_
        orderID = orderID_
        orderType = orderType_
        paymentID = paymentID_
        paymentStatus = paymentStatus_
        transDate = transDate_
        paymentGateWay = PaymentGateWay_
        paymentMode = paymentMode_
    }
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        eRRORCode <- map["ERROR_Code"]
        orderID <- map["OrderID"]
        orderType <- map["OrderType"]
        paymentID <- map["PaymentID"]
        paymentStatus <- map["PaymentStatus"]
        transDate <- map["TransDate"]
        paymentMode <- map["PaymentMode"]
        paymentGateWay <- map["PaymentGateWay"]
        
    }
}

class CashFreeTokenModal : Mappable {
   
    var orderId : String?
    var orderAmount : String?
    var orderCurrency : String?
    
    init(orderID_ : String?, orderAmount_ : String?, orderCurrency_ : String?) {
        orderId = orderID_
        orderAmount = orderAmount_
        orderCurrency = orderCurrency_
    }
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        orderId <- map["orderId"]
        orderAmount <- map["orderAmount"]
        orderCurrency <- map["orderCurrency"]
    }
   
}
