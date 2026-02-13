

//
//  StoresModal.swift
//  Dodoo
//
//  Created by Shubham on 25/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

//{
//    "Address": "Shubash Road, Near Raghuveera towers, Anantapur, Andhra Pradesh 515001",
//    "Category": null,
//    "City": "Anantapur",
//    "CityCode": "ATP",
//    "CloseTime": "21:30",
//    "DeliveryTime": "20 mins",
//    "Email": "test_test@gmail.com",
//    "ImagePath": "StoreImages\/MadhuPulkas.jpeg",
//    "IsActive": true,
//    "IsStoreOpen": true,
//    "Lattitude": "14.679716357412236",
//    "Location": "Anantapur",
//    "Longitude": "77.5983815253575",
//    "MinOrder": "0",
//    "Mobile": "9703001155",
//    "OpenTime": "07:00",
//    "ShowOrder": "2",
//    "StoreName": "Madhu Pulkas",
//    "cod": true,
//    "id": "5c0e3293ce142a11dc92d979",
//    "message": null,
//    "online": true,
//    "reg_id": null,
//    "status": null
//}

class StoresModal : Mappable{
    
    var address : String?
    var Category : String?
    var City : String?
    var DeliveryTime : String?
    var Email : String?
    var ImagePath : String?
    var Location : String?
    var MinOrder : String?
    var Mobile : String?
    var StoreName : String?
    var id : String?
    var Star : String?
    var IsStoreOpen : Bool?
    var CityCode : String?
    var Longitude : String?
    var Lattitude : String?
    var cod : Bool?
    var online : Bool?
    var storeID : String?
    var storecoupons: [Storecoupons]?
    
    init () {
        
    }
    required init?(map: Map) {
        
        address <- map["Address"]
        Category <- map["Category"]
        City <- map["City"]
        DeliveryTime <- map["DeliveryTime"]
        Email <- map["Email"]
        ImagePath <- map["ImagePath"]
        Location <- map["Location"]
        MinOrder <- map["MinOrder"]
        Mobile <- map["Mobile"]
        StoreName <- map["StoreName"]
        id <- map["id"]
        if /id?.isEmpty {
            id <- map["StoreID"]
        }
        Star <- map["Star"]
        CityCode <- map["CityCode"]
        IsStoreOpen  <- map["IsStoreOpen"]
        Longitude  <- map["Longitude"]
        Lattitude  <- map["Lattitude"]
        cod <- map["cod"]
        online <- map["online"]
        storeID <- map["StoreID"]
        storecoupons <- map["storecoupons"]
        
    }
    
    func mapping(map: Map) {
        
        address <- map["Address"]
        Category <- map["Category"]
        City <- map["City"]
        DeliveryTime <- map["DeliveryTime"]
        Email <- map["Email"]
        ImagePath <- map["ImagePath"]
        Location <- map["Location"]
        MinOrder <- map["MinOrder"]
        Mobile <- map["Mobile"]
        StoreName <- map["StoreName"]
        id <- map["id"]
        if /id?.isEmpty {
            id <- map["StoreID"]
        }
        Star <- map["Star"]
        CityCode <- map["CityCode"]
        IsStoreOpen  <- map["IsStoreOpen"]
        Longitude  <- map["Longitude"]
        Lattitude  <- map["Lattitude"]
        cod <- map["cod"]
        online <- map["online"]
        storeID <- map["StoreID"]
        storecoupons <- map["storecoupons"]
        
    }
    
    init(json : JSON) {
        
        address = json["Address"].stringValue
        Category = json["Category"].stringValue
        City = json["City"].stringValue
        DeliveryTime = json["DeliveryTime"].stringValue
        Email = json["Email"].stringValue
        ImagePath = json["ImagePath"].stringValue
        Location = json["Location"].stringValue
        MinOrder = json["MinOrder"].stringValue
        Mobile = json["Mobile"].stringValue
        StoreName = json["StoreName"].stringValue
        CityCode = json["CityCode"].stringValue
        id = json["id"].stringValue
        if /id?.isEmpty {
            id = json["StoreID"].stringValue
        }
        Star = json["Star"].stringValue
        IsStoreOpen = json["IsStoreOpen"].boolValue
        Longitude = json["Longitude"].stringValue
        Lattitude = json["Lattitude"].stringValue
        Longitude = json["Longitude"].stringValue
        Lattitude = json["Lattitude"].stringValue
        cod = json["cod"].boolValue
        online = json["online"].boolValue
        storeID = json["StoreID"].stringValue
        
        let arr = json["storecoupons"].arrayValue
            
            var storesArr = [Storecoupons]()
            for element in arr {
                let store = Storecoupons.init(json: element)
                storesArr.append(store)
        }
        
        storecoupons = storesArr
        
    }
    
}

class Storecoupons : Mappable {
    var couponType : String?
    var value : String?
    var maxDiscountAmount : String?
    var minCartAmount : String?
    var description : String?
    var storeId : String?
    var validFrom : String?
    var validUpto : String?
    var couponCode : String?
    var maxTimes : String?
    var deductionType : String?
    var minDiscountAmount : String?
    var id : String?

    
    init () {
        
    }
    
    required init?(map: Map) {

        couponType <- map["CouponType"]
        value <- map["Value"]
        maxDiscountAmount <- map["MaxDiscountAmount"]
        minCartAmount <- map["MinCartAmount"]
        description <- map["Description"]
        storeId <- map["StoreId"]
        validFrom <- map["ValidFrom"]
        validUpto <- map["ValidUpto"]
        couponCode <- map["CouponCode"]
        maxTimes <- map["MaxTimes"]
        deductionType <- map["DeductionType"]
        minDiscountAmount <- map["MinDiscountAmount"]
        id <- map["id"]
    }

    func mapping(map: Map) {

        couponType <- map["CouponType"]
        value <- map["Value"]
        maxDiscountAmount <- map["MaxDiscountAmount"]
        minCartAmount <- map["MinCartAmount"]
        description <- map["Description"]
        storeId <- map["StoreId"]
        validFrom <- map["ValidFrom"]
        validUpto <- map["ValidUpto"]
        couponCode <- map["CouponCode"]
        maxTimes <- map["MaxTimes"]
        deductionType <- map["DeductionType"]
        minDiscountAmount <- map["MinDiscountAmount"]
        id <- map["id"]
    }
    
    init(json : JSON) {
        couponType = json["CouponType"].stringValue
        value = json["Value"].stringValue
        maxDiscountAmount = json["MaxDiscountAmount"].stringValue
        minCartAmount = json["MinCartAmount"].stringValue
        description = json["Description"].stringValue
        storeId = json["StoreId"].stringValue
        validFrom = json["ValidFrom"].stringValue
        validUpto = json["ValidUpto"].stringValue
        couponCode = json["CouponCode"].stringValue
        maxTimes = json["MaxTimes"].stringValue
        deductionType = json["DeductionType"].stringValue
        minDiscountAmount = json["MinDiscountAmount"].stringValue
        id = json["id"].stringValue
    }

}

