

//
//  CouponCodeModal.swift
//  Dodoo
//
//  Created by Shubham on 11/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import  UIKit
import  ObjectMapper

class CouponCodeModal : Mappable {

    var validUpto : String?
    var deductionType : String?
    var description : String?
    var value : String?
    var validFrom : String?
    var id : String?
    var CouponCode : String?
    var CouponType : String?
    var message : String?
    
    
    func mapping(map: Map) {
        validUpto <- map["ValidUpto"]
        deductionType <- map["DeductionType"]
        description <- map["Description"]
        value <- map["Value"]
        validFrom <- map["ValidFrom"]
        id <- map["id"]
        CouponCode <- map["CouponCode"]
        CouponType <- map["CouponType"]
        message <- map["Message"]
    }
    
    
    required init?(map: Map) {
        validUpto <- map["ValidUpto"]
        deductionType <- map["DeductionType"]
        description <- map["Description"]
        value <- map["Value"]
        validFrom <- map["ValidFrom"]
        id <- map["id"]
        CouponCode <- map["CouponCode"]
        CouponType <- map["CouponType"]
        message <- map["Message"]

    }
}
