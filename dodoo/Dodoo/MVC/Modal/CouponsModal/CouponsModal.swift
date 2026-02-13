//
//  CouponsModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/7/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper


class Coupon :  Mappable{

    var couponCode : String?
    var couponType : String?
    var deductionType : String?
    var descriptionField : String?
    var maxTimes : AnyObject?
    var message : AnyObject?
    var status : AnyObject?
    var successMessge : AnyObject?
    var validFrom : String?
    var validUpto : String?
    var value : String?
    var id : String?
    var isUsed : Bool?

    required init?(map: Map){
        couponCode <- map["CouponCode"]
        couponType <- map["CouponType"]
        deductionType <- map["DeductionType"]
        descriptionField <- map["Description"]
        maxTimes <- map["MaxTimes"]
        message <- map["Message"]
        status <- map["Status"]
        successMessge <- map["SuccessMessge"]
        validFrom <- map["ValidFrom"]
        validUpto <- map["ValidUpto"]
        value <- map["Value"]
        id <- map["id"]
        isUsed <- map["isUsed"]
    }
    
    func mapping(map: Map){
        couponCode <- map["CouponCode"]
        couponType <- map["CouponType"]
        deductionType <- map["DeductionType"]
        descriptionField <- map["Description"]
        maxTimes <- map["MaxTimes"]
        message <- map["Message"]
        status <- map["Status"]
        successMessge <- map["SuccessMessge"]
        validFrom <- map["ValidFrom"]
        validUpto <- map["ValidUpto"]
        value <- map["Value"]
        id <- map["id"]
        isUsed <- map["isUsed"]
        
    }
}
