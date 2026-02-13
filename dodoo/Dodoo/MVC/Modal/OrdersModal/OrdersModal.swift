//
//  OrdersModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/6/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class OrdersModal : Mappable{
    
    var dlvryBoyName : String?
    var id : String?
    var orderDate : String?
    var orderID : String?
    var orderType : String?
    var status : String?
    var totalPrice : String?
    var title : String?
    var isSelected : Bool = false
    
    
    required init?(map: Map) {
        
        dlvryBoyName <- map["DlvryBoyName"]
        id <- map["id"]
        orderDate <- map["orderDate"]
        orderID <- map["OrderID"]
        orderType <- map["OrderType"]
        status <- map["Status"]
        totalPrice <- map["TotPrice"]
        title <- map["Title"]
    
    }
    
    init(orderId_ : String? , orderType_ : String?) {
        self.orderID = orderId_
        self.orderType = orderType_
    }
    
    func mapping(map: Map) {
       
        dlvryBoyName <- map["DlvryBoyName"]
        id <- map["id"]
        orderDate <- map["orderDate"]
        orderID <- map["OrderID"]
        orderType <- map["OrderType"]
        status <- map["Status"]
         title <- map["Title"]
        totalPrice <- map["TotPrice"]
   
    }
    
    init(json : JSON) {
        
        dlvryBoyName = json["DlvryBoyName"].stringValue
        id = json["id"].stringValue
        orderDate = json["OrderDate"].stringValue
        orderID = json["OrderID"].stringValue
        orderType = json["OrderType"].stringValue
        status = json["Status"].stringValue
        totalPrice = json["TotPrice"].stringValue
         title = json["Title"].stringValue
   
    }
    
    
    
}
