

//
//  OrderDetailModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 2/11/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON


class OrderDetailModal : Mappable{
    
    var cartItems : [CartItem]?
    var contactNo : String?
    var date : String?
    var desc : String?
    var dropAddress : String?
    var id : String?
    var landMarkDropAddress : String?
    var lattitude : String?
    var longitude : String?
    var name : String?
    var orderDate : String?
    var orderID : String?
    var paymentMode : String?
    var pickpAddress : String?
    var price : String?
    var promoCode : String?
    var ratings : [Int]?
    var saveAddress : Bool?
    var status : String?
    var storeID : String?
    var time : String?
    var title : String?
    var totPrice : String?
    var userID : String?
    var WalletAmount: String?
    var Tax: String?
    var DeliveryCharge: String?
    var PromoCode: String?
    var Address: String?
    var DelvryCycle: String?
    var ContactNo: String?
    var Name: String?
    var Title: String?
    var Desc: String?
    
    required init?(map: Map) {
        
        
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        var cartItems = [CartItem]()
        let cartItemsArray = json["cartItems"].arrayValue
        for cartItemsJson in cartItemsArray{
            let value = CartItem(fromJson: cartItemsJson)
            cartItems.append(value)
        }
        self.cartItems = cartItems
        contactNo = json["ContactNo"].stringValue
        date = json["Date"].stringValue
        desc = json["Desc"].stringValue
        dropAddress = json["DropAddress"].stringValue
        id = json["id"].stringValue
        landMarkDropAddress = json["LandMarkDropAddress"].stringValue
        lattitude = json["Lattitude"].stringValue
        longitude = json["Longitude"].stringValue
        name = json["Name"].stringValue
        orderDate = json["OrderDate"].stringValue
        orderID = json["OrderID"].stringValue
        paymentMode = json["PaymentMode"].stringValue
        pickpAddress = json["PickpAddress"].stringValue
        price = json["Price"].stringValue
        promoCode = json["PromoCode"].stringValue
        var ratings = [Int]()
        let ratingsArray = json["Ratings"].arrayValue
        for ratingsJson in ratingsArray{
            ratings.append(ratingsJson.intValue)
        }
        self.ratings = ratings
        saveAddress = json["SaveAddress"].boolValue
        status = json["Status"].stringValue
        storeID = json["StoreID"].stringValue
        time = json["Time"].stringValue
        title = json["Title"].stringValue
        totPrice = json["TotPrice"].stringValue
        userID = json["UserID"].stringValue
        WalletAmount = json["WalletAmount"].stringValue
        Tax = json["Tax"].stringValue
        DeliveryCharge = json["DeliveryCharge"].stringValue
        PromoCode = json["PromoCode"].stringValue
        Address = json["Address"].stringValue
        DelvryCycle = json["DelvryCycle"].stringValue
        ContactNo = json["ContactNo"].stringValue
        Name = json["Name"].stringValue
    }
    
    
    func mapping(map: Map) {
        cartItems <- map["cartItems"]
        contactNo <- map["contactNo"]
        date <- map["date"]
        desc <- map["desc"]
        dropAddress <- map["dropAddress"]
        id <- map["id"]
        landMarkDropAddress <- map["landMarkDropAddress"]
        lattitude <- map["lattitude"]
        longitude <- map["longitude"]
        name <- map["name"]
        orderDate <- map["orderDate"]
        orderID <- map["orderID"]
        paymentMode <- map["paymentMode"]
        pickpAddress <- map["pickpAddress"]
        price <- map["price"]
        promoCode <- map["promoCode"]
        ratings <- map["ratings"]
        saveAddress <- map["saveAddress"]
        status <- map["status"]
        storeID <- map["storeID"]
        time <- map["time"]
        title <- map["title"]
        totPrice <- map["totPrice"]
        userID <- map["userID"]
        WalletAmount <- map["WalletAmount"]
        Tax <- map["Tax"]
        DeliveryCharge <- map["DeliveryCharge"]
        PromoCode <- map["PromoCode"]
        Address <- map["Address"]
        DelvryCycle <- map["DelvryCycle"]
        ContactNo <- map["ContactNo"]
        Name <- map["Name"]
    }
    
}



class CartItem : Mappable {
    
    var desc : String?
    var price : String?
    var qty : String?
    var title : String?
    
    required init?(map: Map) {
        
        
    }
    
    init(Title_ : String? , Desc_ : String? , Price_ : String? , Qty_ : String?) {
        title = Title_
        desc = Desc_
        price = Price_
        qty = Qty_
    }
    
    func mapping(map: Map) {
        
        desc <- map["desc"]
        price <- map["price"]
        qty <- map["qty"]
        title <- map["title"]
        
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        desc = json["Desc"].stringValue
        price = json["Price"].stringValue
        qty = json["Qty"].stringValue
        title = json["Title"].stringValue
    }
}


