//
//  Login.swift
//  APISampleClass
//
//  Created by cbl20 on 2/23/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import EZSwiftExtensions

enum HomeEndpoint {
   
    case getCategories(value : String?)
    case getStores(CatID : String? , place : String?)
    case getStoresItem(StoreID : String?)
    case getAppVersion
    case saveStoreOrders(details : [String : Any]?)
    case getConfigurations(cityCode : String?)
    case applyCoupon(promoCode : String? , UserID : String? , storeID : String?)
    case getOffers
    case getWalletInfo(userID : String?)
    case updateOrderStatus(OrderType : String? , OrderStatus : String? , OrderID : String?)
    case getAllCoupons(cityCode : String?)
    case getAllCouponsByStore(storeId : String?)
    case orderPaymentInfo(paymentInfo : [String : Any]?)
    case getAddressesList(Userid : String?)
    case deleteAddress(details : [String : Any]?)
    case addOrUpdateAddress(details : [String : Any]?)
    case searchStore(text: String?)
    case getStoreByLatLong(userID: String? , lat : String? , long : String?)
    case getOperatingLocations(lat: Double?, long: Double?)
    case getCashFreeToken(details : [String : Any]? , env : String?)
    case rateOrder(details : [String : Any]?)
}


extension HomeEndpoint : Router{
    
    var route : String  {
        
        switch self {
        case .getCategories(let value):
            return "\(APIConstants.getCategories)\(/value)"
            
        case .getStores(let CatId , let place):
            if let catID = CatId , let place = place {
                return "\(APIConstants.getStores)\(catID)/\(place)"
            }
            return APIConstants.getStores
            
        case .getStoresItem(let storeID):
            if let storeID = storeID {
               return "\(APIConstants.getStoreItem)\(storeID)"
            }
            return ""
            
        case .getAppVersion:
            return APIConstants.apiLatestVersion
            
        case .getAllCoupons(let cityCode):
            return "\(APIConstants.getAllCouponsByCity)\(/cityCode)"
            
        case .saveStoreOrders(_):
            return APIConstants.saveStoreOrders
            
        case .getConfigurations(let cityCode):
            return "\(APIConstants.getConfigurationsByCity)\(/cityCode)"
            
        case .applyCoupon(let promoCode,let UserID , let storeID):
            return "\(APIConstants.applyCoupon)\(/UserID)/\(/promoCode)/\(/storeID)"
            
        case .getOffers:
            return APIConstants.getOffers
        
        case .getWalletInfo(let userID):
            return "\(APIConstants.getWalletInfo)\(/userID)"
            
        case .updateOrderStatus(let orderType , let orderStatus , let orderID):
            return "\(APIConstants.updateOrderStatus)\(/orderType)/\(/orderStatus)/\(/orderID)"
       
        case .orderPaymentInfo(_):
            return "\(APIConstants.orderPaymentInfo)"
            
        case .getAddressesList(let userID):
            return "\(APIConstants.getUsersAddress)\(/userID)"
            
        case .deleteAddress(_):
            return APIConstants.deleteAddress
        
        case .addOrUpdateAddress(_):
            return APIConstants.addorUpdatenewAddress
            
        case .searchStore(let text):
            if let cityCode = UDKeys.CityCode.fetch() as? String {
                return "\(APIConstants.searchStore)\(/text)/\(cityCode)"
            }
           
        
        case .getAllCouponsByStore(let storeID):
            return "\(APIConstants.getAllCouponsByStore)/\(/storeID)"
            
        case .getStoreByLatLong(let userID , let lat, let long):
            return "\(APIConstants.getStoresByLatLong)\(/userID)/\(/lat)/\(/long)"
        case .getOperatingLocations(let lat, let long):
                return "\(APIConstants.GetOperatingLocationsByLongLat)\(/lat)/\(/long)"
        case .getCashFreeToken(_,let env):
            if env == "TEST" {
                return APIConstants.getCashFreeTokenForSandbox
            }
            else {
                return APIConstants.getCashFreeToken
            }
        case .rateOrder(_):
            return APIConstants.ratingToOrder
        }
        
        
        return ""
    }
    
    var parameters: OptionalDictionary{
        return format()
        
    }
    
    func format() -> OptionalDictionary {
        //    let  deviceType = "IOS", version = ez.appVersion
        //          let  appdelegate = UIApplication.shared.delegate as? AppDelegate, deviceType = "IOS", version = ez.appVersion
        
        switch self {
        case .saveStoreOrders(let details) , .orderPaymentInfo(let details) , .deleteAddress(let details) , .addOrUpdateAddress(let details) ,.getCashFreeToken(let details , _) , .rateOrder(let details):
            return Parameters.details.map(values: [details])
       
        default :
            return [:]
        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
        case .getCategories(_) , .getStores(_,_) , .getStoresItem(_) , .getAppVersion , .getConfigurations(_), .applyCoupon(_,_,_) , .getOffers , .getWalletInfo(_) , .updateOrderStatus(_,_,_) ,.getAllCoupons(_) , .getAllCouponsByStore(_) , .getAddressesList(_),.searchStore(_) , .getStoreByLatLong(_,_,_) , .getOperatingLocations:
            return .get
            
            default :
                return .post
        }
    }
    
    var baseURL: String{
        return APIConstants.basePath
    }
    
    var header : [String: String]{
        return [:]
    }
    
    
}




