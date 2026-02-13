//
//  UDKeys.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/27/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import ObjectMapper

enum UDKeys: String{
    
    case AccessToken = "AccessToken"
    case UserDTL    = "UserDTL"
    case FCMToken = "FCMToken"
    case CurrentCity = "CurrentCity"
    case CurrentLat = "CurrentLat"
    case CurrentLong = "CurrentLong"
    case UsedCity = "UsedCity"
    case UsedLat = "UsedLat"
    case UsedLong = "UsedLong"
    case CityCode = "CityCode"
    case APP_OPENED_COUNT = "APP_OPENED_COUNT"
    case lastVersionPromptedForReviewKey = "lastVersionPromptedForReviewKey"
    
    
    func save(_ value: Any) {
        
        switch self{
            
        case .UserDTL:
            if let value = value as? UserDetails {
                UserDefaults.standard.set(value.toJSON(), forKey: self.rawValue)
            }
            
        default:
            UserDefaults.standard.set(value, forKey: self.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func fetch() -> Any? {
        
        switch self{
            
        case .UserDTL :
            guard let data = UserDefaults.standard.value(forKey: self.rawValue) else {
                let mappedModel = Mapper<UserDetails>().map(JSON: [:])
                return mappedModel
            }
            let mappedModel = Mapper<UserDetails>().map(JSON: data as! [String : Any])
            return mappedModel
            
        default:
            guard let value = UserDefaults.standard.value(forKey: self.rawValue) else { return nil}
            return value
        }
    }
    
    func remove() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
    
}
