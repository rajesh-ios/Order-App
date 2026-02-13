//
//  StoreItemModal.swift
//  Dodoo
//
//  Created by Shubham on 02/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SwiftyJSON

class StoreItemModal : Mappable{
    
    var Category : [ItemCategory]?
    var items : [Items]?
    
    required init?(map: Map) {
        items <- map["Items"]
    }
    
    func mapping(map: Map) {
        items <- map["Items"]
    }
    
    init(json : JSON) {
//        items = json["Items"].arrayValue
    }
}


class  Items : Mappable {
    
    var ItemName : String?
    var Category : String?
    var UnitPrice : String?
    var DishType : String?
    var UnitType : String?
    var quantity : Int = 0
    
    
    init() {
    }
    
    required init?(map: Map) {
        ItemName <- map["ItemName"]
        Category <- map["Category"]
        UnitPrice <- map["UnitPrice"]
        DishType <- map["DishType"]
        UnitType <- map["UnitType"]
        
    }
    
    
    func mapping(map: Map) {
        ItemName <- map["ItemName"]
        Category <- map["Category"]
        UnitPrice <- map["UnitPrice"]
        DishType <- map["DishType"]
        UnitType <- map["UnitType"]
        
        
    }
    
    init(json : JSON) {
        ItemName = json["ItemName"].stringValue
        Category = json["Category"].stringValue
        UnitPrice = json["UnitPrice"].stringValue
        DishType = json["DishType"].stringValue
        UnitType = json["UnitType"].stringValue
    }
}


class ItemCategory : Mappable {
    
    var categoryName : String?
    var items : [Items]?
    
    required init?(map: Map) {
        items <- map["Items"]
        categoryName <- map["Category"]
    }
    
    init(categoryName_ : String? , items_ : [Items]?) {
        categoryName = categoryName_
        items = items_
    }
    
    init(categoryName_ : String?) {
        categoryName = categoryName_
    }
    
    
    func mapping(map: Map) {
        items <- map["Items"]
         categoryName <- map["Category"]
    }
    
    init(json : JSON) {
        //        items = json["Items"].arrayValue
    }
}


class CartItems : Mappable {
    
    var Title : String?
    var Price : String?
    var Desc : String?
    var Qty : String?
 
    
    init() {
    }
    
    init(Title_ : String? , Desc_ : String? , Price_ : String? , Qty_ : String?) {
        Title = Title_
        Desc = Desc_
        Price = Price_
        Qty = Qty_
    }
    
    
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        Title <- map["Title"]
        Price <- map["Price"]
        Desc <- map["Desc"]
        Qty <- map["Qty"]
    }
    
    init(json : JSON) {
        Title = json["Title"].stringValue
        Price = json["Price"].stringValue
        Desc = json["Desc"].stringValue
        Qty = json["Qty"].stringValue
    }
}

