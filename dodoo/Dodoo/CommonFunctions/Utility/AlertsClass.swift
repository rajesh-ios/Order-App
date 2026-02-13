//
//  AlertsClass.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 23/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit
//import EZSwiftExtensions


typealias AlertBlock = (_ success: AlertTag) -> ()
enum AlertTag {
    case done
    case yes
    case no
}

class AlertsClass: NSObject, FCAlertViewDelegate{
  
    
    static let shared = AlertsClass()
    var responseBack : AlertBlock?
    
    var alertView: FCAlertView = {
        let alert = FCAlertView()
        alert.dismissOnOutsideTouch = true
        
        return alert
    }()
    
    override init() {
        super.init()
    }
    
    
    
    //MARK: Alert Controller
    
    func showAlertController(withTitle title : String?, message : String, buttonTitles : [String], responseBlock : @escaping AlertBlock){
        
        alertView = FCAlertView()
        alertView.delegate = self
        responseBack = responseBlock
        alertView.colorScheme = UIColor.ColorApp
        alertView.numberOfButtons = 2
        buttonTitles.count > 0 ? (alertView.hideDoneButton = true) : (alertView.hideDoneButton = false)
        
        alertView.showAlert(inView: ez.topMostVC, withTitle: title, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: buttonTitles.count > 0 ? buttonTitles : nil)
        
    }
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        switch index {
        case 0:
            responseBack?(.yes)
        case 1:
            responseBack?(.no)
        default: return
        }
    }
    
}



