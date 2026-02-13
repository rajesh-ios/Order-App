

//
//  PriceCalculationModal.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/6/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON


class PriceCalculationModal : Mappable{
    
    var itemTitle : String?
    var itemValue : String?
    var unitMeasure : String?
    var id : String?
    
    required init?(map: Map) {
        itemTitle <- map["ItemTitle"]
        itemValue <- map["ItemValue"]
        unitMeasure <- map["UnitMeasure"]
        id <- map["id"]
    }
    
    func mapping(map: Map) {
        itemTitle <- map["ItemTitle"]
        itemValue <- map["ItemValue"]
        unitMeasure <- map["UnitMeasure"]
        id <- map["id"]
    }
    
    
    init(json : JSON) {
        itemTitle = json["ItemTitle"].stringValue
        itemValue = json["ItemValue"].stringValue
        unitMeasure = json["UnitMeasure"].stringValue
        id = json["id"].stringValue
    }
    
}
