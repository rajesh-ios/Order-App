//
//  ServiceListModal.swift
//  Dodoo
//
//  Created by Banka Rajesh on 27/08/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class ServiceListModal : Mappable {
    var city : String?
    var cityCode : String?
    var isActive : Bool?
    var latitude : String?
    var locationCode : String?
    var locationId : String?
    var locationName : String?
    var longitude : String?
    var minAmount : Int?
    var minKM : String?
    var perKMCharge : Double?

    init () {
        
    }
    
    required init?(map: Map) {
        
        city <- map["City"]
        cityCode <- map["CityCode"]
        isActive <- map["IsActive"]
        latitude <- map["Latitude"]
        locationCode <- map["LocationCode"]
        locationId <- map["LocationId"]
        locationName <- map["LocationName"]
        longitude <- map["Longitude"]
        minAmount <- map["MinAmount"]
        minKM <- map["MinKM"]
        perKMCharge <- map["PerKMCharge"]
        
    }

    func mapping(map: Map) {

        city <- map["City"]
        cityCode <- map["CityCode"]
        isActive <- map["IsActive"]
        latitude <- map["Latitude"]
        locationCode <- map["LocationCode"]
        locationId <- map["LocationId"]
        locationName <- map["LocationName"]
        longitude <- map["Longitude"]
        minAmount <- map["MinAmount"]
        minKM <- map["MinKM"]
        perKMCharge <- map["PerKMCharge"]
    }
    
    init(json : JSON) {
        
        city = json["City"].stringValue
        cityCode = json["CityCode"].stringValue
        isActive = json["IsActive"].boolValue
        latitude = json["Latitude"].stringValue
        locationCode = json["LocationCode"].stringValue
        locationId = json["LocationId"].stringValue
        locationName = json["LocationName"].stringValue
        longitude = json["Longitude"].stringValue
        minAmount = json["MinAmount"].intValue
        minKM = json["MinKM"].stringValue
        perKMCharge = json["PerKMCharge"].doubleValue
    }

}

