
//
//  RegisterModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/16/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper

class ParentResponseModal : Mappable {
    
    var RegisterUserInfoResult : UserDetails?
    var RegisterSupportResult : RegisterModal?
    var RegisterFeedbackResult : RegisterModal?
    
    required init?(map: Map) {
        RegisterUserInfoResult <- map["RegisterUserInfoResult"]
        RegisterSupportResult <- map["RegisterSupportResult"]
         RegisterFeedbackResult <- map["RegisterFeedbackResult"]
        
    }
    
    func mapping(map: Map) {
        RegisterUserInfoResult <- map["RegisterUserInfoResult"]
         RegisterSupportResult <- map["RegisterSupportResult"]
        RegisterFeedbackResult <- map["RegisterFeedbackResult"]

    }
    
}

class RegisterModal : Mappable {
    
    var id : String?
    var email : String?
    var password : String?
    var mobno : String?
    var reg_id : String?
    var Address : String?
    var name : String?
    var Status : String?
    var Result : String?
    var ImageName : String?
    var docName : String?
    var ReferredByCode : String?
    
    
    
    init(id_ : String? , name_ : String? , email_ : String? ,mobno_ : String? , password_ : String? , address_ : String? , imageName_ : String? , docName_ : String? ,ReferredByCode_ : String? = "") {
        
        name = name_
        email = email_
        mobno = mobno_
        password = password_
        id = id_
        Address = address_
        reg_id = ""
        if let token = UDKeys.FCMToken.fetch() as? String {
            reg_id = token
        }
        
        ImageName = imageName_
        if let docNamee = docName_ {
         docName = docNamee
        }
        else {
        docName = ""
        }
        
        if let referredByCode = ReferredByCode_ {
            ReferredByCode = referredByCode
        }
        else {
            ReferredByCode = ""
        }
       
        
    }
    required init?(map: Map) {
        id <- map["id"]
        email <- map["email"]
        password <- map["password"]
        mobno <- map["mobno"]
        reg_id <- map["reg_id"]
        Address <- map["address"]
        name <- map["name"]
        Status <- map["Status"]
        Result <- map["Result"]
        ImageName <- map["ImageName"]
        docName <- map["docName"]
        ReferredByCode <- map["ReferredByCode"]
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        password <- map["password"]
        mobno <- map["mobno"]
        reg_id <- map["reg_id"]
        Address <- map["address"]
        name <- map["name"]
        Result <- map["Result"]
        ImageName <- map["ImageName"]
        docName <- map["docName"]
        ReferredByCode <- map["ReferredByCode"]
        
    }
}
