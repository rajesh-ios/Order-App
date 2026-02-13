
//
//  FeedbackSupportModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/30/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper

class SupportFeedbackModal : Mappable {
    
    var id : String?
    var Typee : String?
    var Desc : String?
    var UserID : String?
    var ImageName : String?
    var Subject : String?
    
    
    init(id_ : String? , Type_ : String? , Desc_ : String? ,UserID_ : String? , ImageName_ : String? , Subject_ : String? ){
        id = id_
        Typee = Type_
        Desc = Desc_
        UserID = UserID_
        ImageName = ImageName_
        Subject = Subject_
    }
    
    required init?(map: Map) {
        id <- map["id"]
        Typee <- map["Type"]
        Desc <- map["Desc"]
        UserID <- map["UserID"]
        ImageName <- map["ImageName"]
        Subject <- map["Subject"]
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        Typee <- map["Type"]
        Desc <- map["Desc"]
        UserID <- map["UserID"]
        ImageName <- map["ImageName"]
        Subject <- map["Subject"]

    }
}
