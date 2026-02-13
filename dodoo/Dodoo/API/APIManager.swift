//
//  APIManager.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Dhingra. All rights reserved.
//
import Foundation
import SwiftyJSON

class APIManager : NSObject{
    
    typealias Completion = (Response) -> ()
    static let shared = APIManager()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var httpClient : HTTPClient = HTTPClient()
    
    func request(with api : Router , isLoader : Bool? = true , completion : @escaping Completion )  {
        
        httpClient.postRequest(withApi: api, success: {[weak self] (data) in
            
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
                let object : AnyObject?
                object = api.handle(data: response)
                completion(Response.success(object))
            
        }, failure: { (message) in
            
            Utility.shared.stopLoader()
            Messages.shared.show(alert: .oops, message: /message, type: .warning)
        })
    }
    
    //Request With Image
    func request(withImage api : Router , image : [UIImage]? , completion: @escaping Completion){
        
        httpClient.postRequestWithImage(withApi: api, image: image, success: {[weak self] (data) in
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
//            if json[APIConstants.status].stringValue == Validate.invalidAccessToken.rawValue{
//                self?.tokenExpired()
//                return
//            }
//
//            if json[APIConstants.status].stringValue == Validate.adminBlocked.rawValue{
//                self?.adminBlocked()
//                return
//            }
//
//
//            let responseType = Validate(rawValue: json[APIConstants.status].stringValue) ?? .failure
//            switch responseType {
//            case .success:
                let object : AnyObject?
                object = api.handle(data: response)
                completion(Response.success(object))
                
//            case .failure:
//                completion(Response.failure(json[APIConstants.message].stringValue))
//            default : break
//            }
           
            }, failure: { (message) in
                
                Utility.shared.stopLoader()
                Messages.shared.show(alert: .oops, message: /message, type: .warning)
        })
    }
    
    
    func tokenExpired(){
        
//        AlertsClass.shared.showAlertController(withTitle: R.string.localizable.sessionExpired(), message:  R.string.localizable.tokenExpire() , buttonTitles: [R.string.localizable.ok()]) { _ in
//
//            self.delegate?.logout()
//        }
    }
    
    func adminBlocked(){
        
//        AlertsClass.shared.showAlertController(withTitle: R.string.localizable.adminBlocked(), message: R.string.localizable.blocked(), buttonTitles: [R.string.localizable.ok()]) { _ in
//            self.delegate?.logout()
//        }
    }
    
    
    func isLoaderNeeded(api : Router) -> Bool{
        
        switch api.route
        {
        case APIConstants.getOffers ,APIConstants.getWalletInfo , APIConstants.getAdvertisement:
            return false
        default:
            return true
        }
    }
    
    
    
    
}
