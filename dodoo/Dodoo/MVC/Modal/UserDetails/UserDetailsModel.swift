
//
//  UserDetailsModel.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/27/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper

class  UserDetails : Mappable {
    
    var docPath : String?
    var message : String?
    var status : String?
    var docName : String?
    var photoasBase64 : String?
    var name : String?
    var imageName : String?
    var email : String?
    var mobno : String?
    var address : String?
    var reg_id : String?
    var imagePath : String?
    var addresses : String?
    var id : String?
    var doc : String?
    var password : String?
    var image : String?
    var updateProfilPic : UIImage?
    var referalCode : String?
    var landMark : String?
    var latitude : Double?
    var longitude : Double?
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        docPath <- map["DocPath"]
        message <- map["message"]
        status <- map["status"]
        docName <- map["DocName"]
        photoasBase64 <- map["photoasBase64"]
        name <- map["name"]
        imageName <- map["ImageName"]
        email <- map["email"]
        mobno <- map["mobno"]
        address <- map["address"]
        reg_id <- map["reg_id"]
        imagePath <- map["ImagePath"]
        addresses <- map["Addresses"]
        id <- map["id"]
        doc <- map["Doc"]
        password <- map["password"]
        image <- map["Image"]
        updateProfilPic <- map["updateProfilPic"]
        referalCode <- map["ReferalCode"]
        landMark <- map["landMark"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
