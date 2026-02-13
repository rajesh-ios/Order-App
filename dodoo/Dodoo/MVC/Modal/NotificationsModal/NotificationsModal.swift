

//
//  NotificationsModal.swift
//  Dodoo
//
//  Created by Shubham on 21/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON


class NotificationModal : Mappable{
    
    var CreatedOn : String?
    var Message : String?
    var NotifRcvrUserId : String?
    var NotificationOn : String?
    var OrderID : String?
    var id : String?
    
    required init?(map: Map) {
        
        CreatedOn <- map["CreatedOn"]
        Message <- map["Message"]
        NotifRcvrUserId <- map["NotifRcvrUserId"]
        NotificationOn <- map["NotificationOn"]
        OrderID <- map["OrderID"]
        id <- map["id"]
        
    }
    
    func mapping(map: Map) {
        
        CreatedOn <- map["CreatedOn"]
        Message <- map["Message"]
        NotifRcvrUserId <- map["NotifRcvrUserId"]
        NotificationOn <- map["NotificationOn"]
        OrderID <- map["OrderID"]
        id <- map["id"]
    
    }
    
   init(fromJson json: JSON!) {
        
        CreatedOn = json["CreatedOn"].stringValue
        Message = json["Message"].stringValue
        NotifRcvrUserId = json["NotifRcvrUserId"].stringValue
        NotificationOn = json["NotificationOn"].stringValue
        OrderID = json["OrderID"].stringValue
        id = json["id"].stringValue
        
    }
    
}
