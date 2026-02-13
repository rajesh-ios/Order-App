//
//  MyAddressesModal.swift
//  Dodoo
//
//  Created by Shubham Dhingra on 28/09/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//
import ObjectMapper
import SwiftyJSON
import Foundation
//{
//        "Address": "LIG 336 , APHB COLONY , MOULALI , HYDERABAD 500032",
//        "Addressid": "5f71fb50a5cb4a0878c0315f",
//        "City": "Hyderabad",
//        "DoorNo": "7-37-2(A)",
//        "Latitude": "1.02",
//        "Longitude": "17.02",
//        "Mobile": "9035083483",
//        "Title": "My Home (1)",
//        "Type": null,
//        "UserID": null,
//        "isCurrentAddress": true
//    }


class MyAddressesModal :  Mappable {
    
    var address : String?
    var Addressid : String?
    var City : String?
    var DoorNo : String?
    var Latitude : String?
    var Longitude : String?
    var Mobile : String?
    var type : String?
    var title : String?
    var UserID : String?
    var isCurrentAddress : Bool?
    
    init (addressId : String? , UserId : String?, Title : String? , Address : String? , isCurrentAddress : Bool? , Mobile : String? , Longitude : String? , Latitude : String? , DoorNo : String? , type : String? , city : String?) {
        
        self.address = Address
        self.Addressid = addressId
        self.Mobile = Mobile
        self.type = type
        self.isCurrentAddress = isCurrentAddress
        self.Latitude = Latitude
        self.Longitude = Longitude
        self.UserID = UserId
        self.title = Title
        self.City = city
        self.DoorNo = DoorNo
    }
    
    init(UserId : String?, AddressId : String?) {
        self.UserID = UserId
        self.Addressid = AddressId
    }
    
    init(UserId : String?, AddressId : String? , isCurrentAddress : Bool?) {
        self.UserID = UserId
        self.Addressid = AddressId
        self.isCurrentAddress = isCurrentAddress
    }
    
    
    required init?(map: Map) {
        
        address <- map["Address"]
        Addressid <- map["Addressid"]
        City <- map["City"]
        DoorNo <- map["DoorNo"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        type <- map["type"]
        Mobile <- map["Mobile"]
        UserID <- map["UserID"]
        title <- map["Title"]
        isCurrentAddress <- map["isCurrentAddress"]
    }
    
    func mapping(map: Map) {
        
        address <- map["Address"]
        Addressid <- map["Addressid"]
        City <- map["City"]
        DoorNo <- map["DoorNo"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        Mobile <- map["Mobile"]
        type <- map["type"]
        title <- map["Title"]
        UserID <- map["UserID"]
        isCurrentAddress <- map["isCurrentAddress"]
        
    }
    
    init(json : JSON) {
        address = json["Address"].stringValue
        Addressid = json["Addressid"].stringValue
        City = json["City"].stringValue
        DoorNo = json["DoorNo"].stringValue
        Latitude = json["Latitude"].stringValue
        Longitude = json["Longitude"].stringValue
        type = json["type"].stringValue
        Mobile = json["Mobile"].stringValue
        UserID = json["UserID"].stringValue
        title  = json["Title"].stringValue
        isCurrentAddress = json["isCurrentAddress"].boolValue
    }
    
}




