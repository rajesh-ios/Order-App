//
//  VersionModal.swift
//  Dodoo
//
//  Created by Shubham on 09/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class VersionModal : Mappable{
    
    var createdOn : String?
    var releasedOn : String?
    var version : String?

    
    required init?(map: Map) {
        createdOn <- map["CreatedOn"]
        releasedOn <- map["ReleasedOn"]
        version <- map["Version"]
    }
    
    func mapping(map: Map) {
        createdOn <- map["CreatedOn"]
        releasedOn <- map["ReleasedOn"]
        version <- map["Version"]
    }


}
