
//  Alerts.swift

//
//  Created by Sierra 4 on 14/07/17.
//  Copyright © 2017 com.example. All rights reserved.


import UIKit
import SwiftMessages

enum Alert : String{
    case success = "Success"
    case oops = "Alert"
    case login = "Login Successfull"
    case ok = "Ok"
    case cancel = "Cancel"
    case error = "Error"
    case warning = "Warning"
}

enum Type{
    case success
    case warning
    case error
    case info
}

class Messages : NSObject {
    
    static let shared = Messages()
    
    
    //MARK: - Show Alert
    func show(alert title : Alert , message : String , type : Type){

        var alertConfig = SwiftMessages.defaultConfig
        alertConfig.presentationStyle = .top
        alertConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
//        alertConfig.presentationContext = .window(windowLevel: (UIWindow.Level(rawValue: UIWindow.Level(rawValue: (UIWindow.Level(rawValue: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue).rawValue)).rawValue).rawValue)).rawValue)
        alertConfig.duration = .seconds(seconds: 2.0)
        
        let alertView = MessageView.viewFromNib(layout: .messageView)
        alertView.button?.isHidden = true
        alertView.configureDropShadow()
        alertView.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        alertView.bodyLabel?.text = message
      alertView.bodyLabel?.font =  UIFont.systemFont(ofSize: 14.0)
        alertView.configureContent(title: title.rawValue, body: message)
        
        switch type {
        case .error:
            alertView.configureTheme(.error)
        case .info:
            alertView.configureTheme(.info)
        case .success:
            alertView.configureTheme(.success)
            alertView.backgroundView.backgroundColor = UIColor.successColor
        case .warning:
            alertView.configureTheme(.warning)
            alertView.backgroundView.backgroundColor = UIColor.flatStepProgress
            
        }
        
        alertView.titleLabel?.textColor = UIColor.white
        alertView.bodyLabel?.textColor = UIColor.white
        
        SwiftMessages.show(config: alertConfig, view: alertView)
      
    }
}

