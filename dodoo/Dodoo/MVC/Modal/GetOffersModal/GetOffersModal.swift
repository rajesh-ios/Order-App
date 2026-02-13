//
//  GetOffersModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/17/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON


class GetOffersModal :  Mappable {
    
    var couponCode : String?
    var couponType : String?
    var deductionType : String?
    var descriptionField : String?
    var imagePath : String?
    var validFrom : String?
    var validUpto : String?
    var value : String?
    var id : String?
    var minDiscountAmount: String?
    var maxDiscountAmount: String?
    var MinCartAmount: String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        couponCode <- map["CouponCode"]
        couponType <- map["CouponType"]
        deductionType <- map["DeductionType"]
        descriptionField <- map["Description"]
        imagePath <- map["ImagePath"]
        validFrom <- map["ValidFrom"]
        validUpto <- map["ValidUpto"]
        value <- map["Value"]
        id <- map["id"]
        minDiscountAmount <- map["MinDiscountAmount"]
        maxDiscountAmount <- map["MaxDiscountAmount"]
        MinCartAmount <- map["MinCartAmount"]
    }
    
    init(json : JSON) {
        couponCode = json["CouponCode"].stringValue
        couponType = json["CouponType"].stringValue
        deductionType = json["DeductionType"].stringValue
        descriptionField = json["Description"].stringValue
        imagePath = json["ImagePath"].stringValue
        validFrom = json["ValidFrom"].stringValue
        validUpto = json["ValidUpto"].stringValue
        value = json["Value"].stringValue
        id = json["id"].stringValue
        minDiscountAmount = json["MinDiscountAmount"].stringValue
        maxDiscountAmount = json["MaxDiscountAmount"].stringValue
        MinCartAmount = json["MinCartAmount"].stringValue
    }
    
}
