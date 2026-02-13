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

protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
    func handle(data : Any) -> AnyObject?
    var header : [String: String] {get}
}

extension Sequence where Iterator.Element == Keys {
    
    func map(values: [Any?]) -> OptionalDictionary {
        
        var params = [String : Any]()
        
        for (index,element) in zip(self,values) {
                params[index.rawValue] = element
        }
        return params
    }
}


enum LoginEndpoint {
    case language
    case register(details : String?)
    case forgotPassword(email : String?)
    case authentication(details : [String : Any]?)
    case supportFeedback(module : Module , details : String?)
    case changePassword(newpassword : String? , userID : String?)
    case allOrders(userID : String? , status : String?)
    case getOrderDetails(orderID : String?)
    case getAdvertisement(cityCode : String?)
    case saveSubscriptionAndPickUpDrop(module : Module , details : [String : Any]?)
    case getNotification(userID : String?)
    case getAppVersion
    case validateUser(email : String?)
    case validateMobileNo(mobileNo : String?)
   
}


extension LoginEndpoint : Router{
    
    var route : String  {
        
        switch self {
      
        case  .getAppVersion : return APIConstants.apiLatestVersion
        case .language: return APIConstants.language
        case .register(_) : return APIConstants.register
        case .authentication(_) : return APIConstants.authentication
        case .getOrderDetails(let orderID):
            if orderID?.contains("STOR") ?? false {
                return "\(APIConstants.orderDetails)\(/orderID)"
            }
            else if orderID?.contains("PDP") ?? false {
                return "\(APIConstants.getPickUpAndDrop)\(/orderID)"
            }
            else {
                return "\(APIConstants.GetSubscriptionByOrderID)\(/orderID)"
            }
            
        case.supportFeedback(let module ,_ ):
            if module == .Support {
                return APIConstants.registerSupport
            }
            else {
                return APIConstants.registerFeedback
            }
        case .forgotPassword(let email):
//            return APIConstants.fo
            return "\(APIConstants.forgotPassword)\(/email)"
        
        case .changePassword(let newpassword,let userID):
            //            return APIConstants.fo
            return "\(APIConstants.changePassword)\(/newpassword)/\(/userID)"
            
        case .allOrders(let userID, let status):
            return "\(APIConstants.getAllTypeOrders)\(/userID)/\(/status)"
        
        case .getAdvertisement(let cityCode):
            return "\(APIConstants.getAdvertisement)/\(/cityCode)"
            
        case .getNotification(let userID):
            return "\(APIConstants.getNotification)\(/userID)"
            
        case .validateUser(let email):
            return "\(APIConstants.validateUser)/\(/email)"
            
        case .validateMobileNo(let mobileNo):
             return "\(APIConstants.validateMobileNo)/\(/mobileNo)"
       
        case .saveSubscriptionAndPickUpDrop(let module ,_):
            if module == .PickUpAndDrop {
                return APIConstants.savePickUpAndDrop
            }
            else {
                return APIConstants.saveSubscription
            }
    }
    }
    
    var parameters: OptionalDictionary{
        return format()
    }
    
    func format() -> OptionalDictionary {
        
        //let  appdelegate = UIApplication.shared.delegate as? AppDelegate,
//        let  deviceType = "IOS", version = ez.appVersion

        switch self {
                        
        case .register(let details) , .supportFeedback(_, let details) :
            return Parameters.details.map(values: [details])
            
        case .authentication(let details) , .saveSubscriptionAndPickUpDrop(_, let details):
            return Parameters.Authentication.map(values: [details])
            
        default:
            return [:]
        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
        case .language  , .forgotPassword(_) ,.changePassword(_,_) , .allOrders(_,_)  , .getOrderDetails(_) , .getAdvertisement(_) , .getNotification(_) ,.getAppVersion , .validateUser(_) , .validateMobileNo(_):
            return .get
            
            default:
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
