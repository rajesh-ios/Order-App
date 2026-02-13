//
//  SocialNetworkClass.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 06/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
//import EZSwiftExtensions
import SwiftyJSON
import GoogleSignIn


typealias SuccessBlock = (_ fbId: String?,_ name : String?, _ email : String?,_ img : String? ) -> ()

class SocialNetworkClass: NSObject, GIDSignInDelegate{
    
    static let shared = SocialNetworkClass()
    var responseBack : SuccessBlock?
   
    
    
    //MARK: Facebook
    
    func facebookLogin(responseBlock : @escaping SuccessBlock) {
        
        responseBack = responseBlock
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logOut()
//        Utility.shared.startLoader()
        
        fbLoginManager.logIn(permissions: ["email","public_profile","user_friends"],from: ez.topMostVC, handler: {[weak self] (result, error) -> Void in
            if (error == nil){
                if let fbloginresult = result{
                    if(fbloginresult.isCancelled) {
                        Utility.shared.stopLoader()
                    }
                    else{self?.handleFbResult()}
                    
                }else{ Utility.shared.stopLoader()
//                    self?.setupFbAnalytics(network: .FacebookFailure, id: "")
                }
            }else{ Utility.shared.stopLoader()
//                self?.setupFbAnalytics(network: .FacebookFailure, id: "")
            }
        })
        
    }
    
    
    func handleFbResult()  {
        
        
        if (AccessToken.current != nil){
            GraphRequest.init(graphPath: "me", parameters: ["fields": "id, name,email,picture.width(300).height(300)"]).start(completionHandler: {[weak self] (connection, result, error) in
                
                self?.hanleResponse(result:(result as AnyObject?))
                
            })
        }else{ Utility.shared.stopLoader()
//            setupFbAnalytics(network: .FacebookFailure, id: "")
        }
        
    }
    
    
    func hanleResponse(result : AnyObject?)
    {
        if let dict = result as? Dictionary<String, AnyObject>{
            let response = JSON(dict)
            let facebookId = dict["id"] as? String
            let email = dict["email"] as? String
            let name = dict["name"] as? String
            
            let imageUrl = response["picture"]["data"]["url"].string
            
            self.responseBack?(facebookId,name,email,imageUrl)
//            setupFbAnalytics(network: .FacebookSuccess, id: /facebookId)
            
        }else{
             Utility.shared.stopLoader()
            
        }
    }
    
    
    //MARK: Google
    
    func googleLogin(responseBlock : @escaping SuccessBlock){
        responseBack = responseBlock
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        if (error == nil) {
            Utility.shared.startLoader()
            
            let googleId = user.userID
            let email = user.profile.email
            let name = user.profile.name
            let imageUser = user.profile.imageURL(withDimension: 400).absoluteString
            
            self.responseBack?(googleId,name,email,imageUser)
//            setupFbAnalytics(network: .GoogleSuccess, id: /googleId)
            
        } else {
            print(error.localizedDescription)
//            setupFbAnalytics(network: .GoogleFailure, id: "")
            Utility.shared.stopLoader()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        
    }

    
}


