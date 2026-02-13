//
//  StoreOrdersModal.swift
//  Dodoo
//
//  Created by Shubham on 06/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class StoreOrdersModal  : Mappable{
    
    var id : String?
    var Name : String?
    var Title : String?
    var Desc : String?
    var ContactNo : String?
    var PickUpAddress : String?
    var DropAddress : String?
    var LandMarkDropAddress : String?
    var Status : String?
    var UserID : String?
    var Date : String?
    var Time : String?
    var SaveAddress : Bool?
    var Price : String?
    var totPrice : String?
    var PaymentMode : String?
    var PromoCode : String?
    var StoreID : String?
    var cartItems : [[String : Any]]?
    var result : String?
    var DeliveryCharge : String?
    var WalletAmount : String?
    var Tax : String?
    var OS : String?
    var CityCode : String?
    var Notes : String?
    init() {
        
    }
    
    required init?(map: Map) {
    
    }
    
    
    init(id_ : String? , name_ : String? , Title_ : String? ,Desc_ : String? , ContactNo_ : String? , pickUpAddress_ : String? , dropAddress_ : String? , Status_ : String? ,  UserID_ : String? , date_ : String? , time_ : String?, SaveAddress_ : Bool? , LandMarkDropAddress_ : String? , Price_ : String? , StoreID_ : String? , cartItems_ : [[String : Any]]? , CityCode_ : String?) {
        
        id = id_
        Name = name_
        Title = Title_
        Desc = Desc_
        ContactNo = ContactNo_
        Status = Status_
        UserID = UserID_
        SaveAddress = SaveAddress_
        PickUpAddress = pickUpAddress_
        DropAddress = dropAddress_
        LandMarkDropAddress = LandMarkDropAddress_
        Date  = date_
        Time = time_
        Price = Price_
        StoreID = StoreID_
        cartItems = cartItems_
        PaymentMode = ""
        totPrice = ""
        OS = "iOS"
        CityCode = CityCode_
//        DeliveryCharge = deliveryCharge
//        WalletAmount = WalletAmount_
//        Tax = Tax_
//        PromoCode = PromoCode_
    }
    
    
    func mapping(map: Map) {
        
        id <- map["id"]
        Name <- map["Name"]
        Title <- map["Title"]
        Desc <- map["Desc"]
        ContactNo <- map["ContactNo"]
        PickUpAddress <- map["PickpAddress"]
        DropAddress <- map["DropAddress"]
        LandMarkDropAddress <- map["LandMarkDropAddress"]
        Status <- map["Status"]
        UserID <- map["UserID"]
        Date <- map["Date"]
        Time <- map["Time"]
        SaveAddress <- map["SaveAddress"]
        Price <- map["Price"]
        totPrice <- map["TotPrice"]
        PaymentMode <- map["PaymentMode"]
        PromoCode <- map["PromoCode"]
        StoreID <- map["StoreID"]
        cartItems <- map["cartItems"]
        result <- map["Result"]
        Tax <- map["Tax"]
        OS <- map["OS"]
        DeliveryCharge <- map["DeliveryCharge"]
        WalletAmount <- map["WalletAmount"]
        CityCode <- map["CityCode"]
        Notes  <- map["Notes"]
    }
    
    init(json : JSON) {
        
        
        id = json["id"].stringValue
        Name = json["Name"].stringValue
        Title = json["Title"].stringValue
        Desc = json["Desc"].stringValue
        DropAddress = json["DropAddress"].stringValue
        ContactNo = json["ContactNo"].stringValue
        PickUpAddress = json["PickpAddress"].stringValue
        LandMarkDropAddress = json["LandMarkDropAddress"].stringValue
        Status = json["Status"].stringValue
        UserID = json["UserID"].stringValue
        Date = json["Date"].stringValue
        Time = json["Time"].stringValue
        SaveAddress = json["SaveAddress"].boolValue
        Price = json["Price"].stringValue
        totPrice = json["totPrice"].stringValue
        PaymentMode = json["PaymentMode"].stringValue
        PromoCode = json["PromoCode"].stringValue
        StoreID = json["StoreID"].stringValue
         result = json["Result"].stringValue
        Tax = json["Tax"].stringValue
        OS = json["OS"].stringValue
        DeliveryCharge = json["DeliveryCharge"].stringValue
        WalletAmount = json["WalletAmount"].stringValue
        CityCode = json["CityCode"].stringValue
        Notes  = json["Notes"].stringValue
//        cartItems = json["cartItems"].stringValue
        
        
    }
    
}



