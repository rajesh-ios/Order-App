
//
//  AuthenticationModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/26/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthenticationModal : Mappable {
    
    var userid : String?
    var reg_id : String?
    var Pasword : String?
    var SingleSignon : Bool?
    var SignOnFrom : String?
    
    
    
    
    init(userid_ : String? , reg_id_ : String? ,Pasword_ : String? , SingleSignon_ : Bool? , SignOnFrom_ : String?) {
        
        userid = userid_
        reg_id = reg_id_
        Pasword = Pasword_
        SingleSignon = SingleSignon_
        SignOnFrom = SignOnFrom_
    }
    
    required init?(map: Map) {
        userid <- map["userid"]
        reg_id <- map["reg_id"]
        Pasword <- map["Pasword"]
        SingleSignon <- map["SingleSignon"]
        SignOnFrom <- map["SignOnFrom"]
        
    }
    
    func mapping(map: Map) {
        userid <- map["userid"]
        reg_id <- map["reg_id"]
        Pasword <- map["Pasword"]
        SingleSignon <- map["SingleSignon"]
        SignOnFrom <- map["SignOnFrom"]
    }
}
