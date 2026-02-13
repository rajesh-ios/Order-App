//
//  RatingModal.swift
//  Dodoo
//
//  Created by Apple on 19/02/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class RatingModal  : Mappable{
    
    var id : String?
    var RatingToDlvryBoy : String?
    var RatingToStore : String?
    var OrderId : String?
    var OrderType : String?
    var CommentToDeliveryBoy : String?
    var CommentToStore : String?
 
    
    init() {
        
    }
    
    required init?(map: Map) {
    
    }
    
    
    init(id_ : String? , RatingToDlvryBoy_ : String? , RatingToStore_ : String? ,OrderId_ : String? , OrderType_ : String? , CommentToDeliveryBoy_ : String? , CommentToStore_ : String?) {
        
        id = id_
        RatingToDlvryBoy = RatingToDlvryBoy_
        RatingToStore = RatingToStore_
        OrderId = OrderId_
        OrderType = OrderType_
        CommentToDeliveryBoy = CommentToDeliveryBoy_
        CommentToStore = CommentToStore_

    }
    
    
    func mapping(map: Map) {
        
        id <- map["id"]
        RatingToDlvryBoy <- map["RatingToDlvryBoy"]
        RatingToStore <- map["RatingToStore"]
        OrderId <- map["OrderId"]
        CommentToDeliveryBoy <- map["CommentToDeliveryBoy"]
        CommentToStore <- map["CommentToStore"]
        OrderType <- map["OrderType"]
    }
    
    init(json : JSON) {
        
        id = json["id"].stringValue
        RatingToDlvryBoy = json["RatingToDlvryBoy"].stringValue
        RatingToStore = json["RatingToStore"].stringValue
        OrderId = json["OrderId"].stringValue
        CommentToDeliveryBoy = json["CommentToDeliveryBoy"].stringValue
        CommentToStore = json["CommentToStore"].stringValue
        OrderType = json["OrderType"].stringValue
        
    }
    
}




