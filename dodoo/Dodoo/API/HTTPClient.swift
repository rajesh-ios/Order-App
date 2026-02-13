//
//  HTTPClient.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpClientSuccess = (Any?) -> ()
typealias HttpClientFailure = (String) -> ()

class HTTPClient {
    
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }
    
    func postRequest(withApi api : Router , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ){
        var parameters : [String : Any]?
        var parameterEncoding : ParameterEncoding?
        switch  api.route {
            
        case APIConstants.authentication , APIConstants.saveSubscription , APIConstants.savePickUpAndDrop , APIConstants.saveStoreOrders , APIConstants.orderPaymentInfo , APIConstants.deleteAddress , APIConstants.addorUpdatenewAddress , APIConstants.getCashFreeToken ,  APIConstants.ratingToOrder:
            
            if let dict = api.parameters?.first?.value as? [String : Any] {
                parameters = dict
                parameterEncoding = JSONEncoding.default
            }
        
        default:
            parameters = api.parameters
              parameterEncoding = URLEncoding.default
        }
        
        let fullPath = api.baseURL + api.route
        print(fullPath)
        print(api.parameters ?? "")
        
        let startDate = Date()
        Alamofire.request(fullPath, method: api.method, parameters:parameters!, encoding: parameterEncoding!, headers: headerNeeded(api: api) ? api.header : nil ).responseJSON { (response) in
            
            let executionTime = Date().timeIntervalSince(startDate).toString
            print("API Response Time :\(executionTime)")
            
            switch response.result {
            case .success(let data):
                success(data)
                
            case .failure(let error):
                failure(error.localizedDescription)
                
            }
        }
    }
    
    func postRequestWithImage(withApi api : Router, image : [UIImage]?, success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure){
        
        guard let params = api.parameters else {failure("empty"); return}
        let fullPath = api.baseURL + api.route
        print(fullPath)
        print(api.parameters?.first?.value ?? "")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if image?.count != 0 {
                switch api.route {
                    
                case APIConstants.register :
                    for (index , img) in (image ?? []).enumerated() {
                        let imageData = img.jpegData(compressionQuality: 0.1)
                        let  currentDate = Date().toString()
                       
                        if index == 0 {
                            let fileName = "file_ios_profile_\(currentDate).jpeg"
                             if let imageData  = imageData {
                                 multipartFormData.append(imageData, withName: "Profile", fileName: fileName, mimeType: "image/jpeg")
                            }
                        }
                        
                        else if index == 1 {
                            let fileName = "file_ios_docx_\(currentDate).jpeg"
                            if let imageData  = imageData {
                                multipartFormData.append(imageData, withName: "Aadhar", fileName: fileName, mimeType: "image/jpeg")

                            }
                        }
                        else {
                          continue
                        }
                    }
                    
                default :
                    if let img = image?[0] {
                        let imageData = img.jpegData(compressionQuality: 0.5)
                        if let imageData =  imageData {
                        multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                        }
                    }
                }
            }
           
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },to: fullPath ,method : api.method, headers : headerNeeded(api: api) ? api.header : nil) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        success(data)
                        
                    case .failure(let error):
                        failure(error.localizedDescription)
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    func postRequestWithDocument(withApi api : Router,documentUrl : URL?, success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure){
        
        guard let params = api.parameters else {failure("empty"); return}
        let fullPath = api.baseURL + api.route
        //print(fullPath)
        //print(params)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let url = documentUrl {
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                multipartFormData.append(data, withName: "file", fileName: "Notes.pdf", mimeType: "application/pdf")
            }
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue
                    )!, withName: key)
            }
            
        }, to: fullPath) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        success(data)
                        
                    case .failure(let error):
                        failure(error.localizedDescription)
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    
    
    func headerNeeded(api : Router) -> Bool{
        switch api.route {
            default :
                return false
        }
    }
}

