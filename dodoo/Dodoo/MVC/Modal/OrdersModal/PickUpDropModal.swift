//
//  PickUpDropModal.swift
//  Dodoo
//
//  Created by Shubham on 15/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//
import ObjectMapper
import Foundation


class PickUpDropModal : Mappable {
    
    var id : String?
    var Name : String?
    var Title : String?
    var Desc : String?
    var ContactNo : String?
    var Address : String?
    var Status : String?
    var UserID : String?
    var DelvryCycle : String?
    var SaveAddress : Bool?
    var LandMarkAddress : String?
    var pickUpAddress : String?
    var dropAddress : String?
    var landMarkPickUpAddress : String?
    var landMarkDropAddress : String?
    var date : String?
    var time : String?
    var price : String?
    var totPrice : String?
    var paymentMode : String?
    var promoCode : String?
    var PickLattitude : String?
    var PickLongitude : String?
    var DropLongitude : String?
    var DropLattitude : String?
    var CityCode : String?
    var Notes : String?
    
    
    //Modal for subscription
    init(id_ : String? , name_ : String? , Title_ : String? ,Desc_ : String? , ContactNo_ : String? , address_ : String? , Status_ : String? ,  UserID_ : String? , DelvryCycle_ : String? , SaveAddress_ : Bool? , LandMarkAddress_ : String?) {
     
        id = id_
        Name = name_
        Title = Title_
        Desc = Desc_
        ContactNo = ContactNo_
        Address = address_
        Status = Status_
        UserID = UserID_
        DelvryCycle =  DelvryCycle_
        SaveAddress = SaveAddress_
        LandMarkAddress = LandMarkAddress_
        
        pickUpAddress = nil
        dropAddress = nil
        landMarkPickUpAddress = nil
        landMarkDropAddress = nil
        date = nil
        time = nil
        price = nil
        totPrice = nil
        //        paymentMode = paymentMode_
        //        promoCode = promoCode_
        PickLattitude = nil
        PickLongitude = nil
        DropLongitude = nil
        DropLattitude = nil
        if let cityCode = UDKeys.CityCode.fetch() as? String {
            CityCode = "\(cityCode)_"
        }
    }
    
    
    //Modal for saveAndDrop
    init(id_ : String? , name_ : String? , Title_ : String? ,Desc_ : String? , ContactNo_ : String? ,  Status_ : String? ,  UserID_ : String? , SaveAddress_ : Bool? ,  date_ : String? , time_ : String? , price_ : String? , totPrice_ : String? , paymentMode_ : String? = "CASH" , promocode_ : String? = "") {
        
        id = id_
        Name = name_
        Title = Title_
        Desc = Desc_
        ContactNo = ContactNo_
        Address = nil
        Status = Status_
        UserID = UserID_
        DelvryCycle =  nil
        SaveAddress = SaveAddress_
        LandMarkAddress = nil
//        pickUpAddress = pickUpAddress_
//        dropAddress = dropAddress_
//        landMarkPickUpAddress = landMarkPickUpAddress_
//        landMarkDropAddress = landMarkDropAddress_
        date = date_
        time = time_
        price = price_
        totPrice = totPrice_
//        PickLattitude = PickLattitude_
//        PickLongitude = PickLongitude_
//        DropLongitude = DropLongitude_
//        DropLattitude = DropLattitude_
        paymentMode = paymentMode_
        promoCode = promocode_
        if let cityCode = UDKeys.CityCode.fetch() as? String {
            CityCode = "\(cityCode)_"
        }
    
    }
   
    required init?(map: Map) {
        
        id <- map["id"]
        Name <- map["Name"]
        Title <- map["Title"]
        Desc <- map["Desc"]
        ContactNo <- map["ContactNo"]
        Address <- map["Address"]
        Status <- map["Status"]
        UserID <- map["UserID"]
        DelvryCycle <- map["DelvryCycle"]
        SaveAddress <- map["SaveAddress"]
        LandMarkAddress <- map["LandMarkAddress"]
        pickUpAddress <- map["PickpAddress"]
        dropAddress <- map["DropAddress"]
        landMarkPickUpAddress <- map["LandMarkPickpAddress"]
        landMarkDropAddress <- map["LandMarkDropAddress"]
        date <- map["Date"]
        time  <- map["Time"]
        totPrice <- map["TotPrice"]
        price <- map["Price"]
        paymentMode <- map["PaymentMode"]
        promoCode <- map["PromoCode"]
        PickLongitude <- map["PickLongitude"]
        PickLattitude <- map["PickLattitude"]
        DropLongitude <- map["DropLongitude"]
        DropLattitude <- map["DropLattitude"]
        Notes <- map["Notes"]
        CityCode <- map["CityCode"]
        if let cityCode = UDKeys.CityCode.fetch() as? String {
            CityCode = "\(cityCode)_"
        }
    }
    
    
    func mapping(map: Map) {
       
        id <- map["id"]
        Name <- map["Name"]
        Title <- map["Title"]
        Desc <- map["Desc"]
        ContactNo <- map["ContactNo"]
        Address <- map["Address"]
        Status <- map["Status"]
        UserID <- map["UserID"]
        DelvryCycle <- map["DelvryCycle"]
        SaveAddress <- map["SaveAddress"]
        LandMarkAddress <- map["LandMarkAddress"]
        pickUpAddress <- map["PickpAddress"]
        dropAddress <- map["DropAddress"]
        landMarkPickUpAddress <- map["LandMarkPickpAddress"]
        landMarkDropAddress <- map["LandMarkDropAddress"]
        date <- map["Date"]
        time  <- map["Time"]
        totPrice <- map["TotPrice"]
        price <- map["Price"]
        paymentMode <- map["PaymentMode"]
        promoCode <- map["PromoCode"]
        PickLongitude <- map["PickLongitude"]
        PickLattitude <- map["PickLattitude"]
        DropLongitude <- map["DropLongitude"]
        DropLattitude <- map["DropLattitude"]
        Notes <- map["Notes"]
        CityCode <- map["CityCode"]
   
    }
}

