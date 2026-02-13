//
//  UtilityFunctions.swift
//  MbKutz
//
//  Created by Aseem 13 on 15/12/16.
//  Copyright © 2016 Taran. All rights reserved.
//

import Foundation
//import EZSwiftExtensions
import AVFoundation
import Photos
import PhotosUI

class UtilityFunctions {
    
    
    static let sharedInstance : UtilityFunctions = {
        let instance = UtilityFunctions()
        return instance
    }()
    
    
    func appendOptionalStrings(withArray array : [String?]) -> String {
        return array.flatMap{$0}.joined(separator: " ")
    }
    
    func show(alert title:String , message:String ,buttonText: String , buttonOk: @escaping () -> ()  ){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.default, handler: nil))
        alertController.addAction(UIAlertAction(title: buttonText , style: UIAlertAction.Style.default, handler: {  (action) in
            buttonOk()
        }))
        alertController.view.tintColor = UIColor.ColorApp
        
        ez.topMostVC?.present(alertController, animated: true, completion: nil)
    }
    
    
    func show(alert title:String , message:String,buttonTitle : String , buttonOk: @escaping () -> ()){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: buttonTitle , style: UIAlertAction.Style.default, handler: {  (action) in
            buttonOk()
        }))
        
        alertController.view.tintColor = UIColor.ColorApp
        ez.topMostVC?.present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetWithStringButtons(  buttons : [String] , success : @escaping (String) -> ()) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for button in buttons{
            let action = UIAlertAction(title: button , style: .default, handler: { (action) -> Void in
                success(button)
            })
            controller.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel) { (button) -> Void in}
        controller.addAction(cancel)
        controller.view.tintColor = UIColor.ColorApp
        ez.topMostVC?.present(controller, animated: true) { () -> Void in
            
        }
    }
    
    
    func isCameraPermission(actionOkButton: ((_ isOk: Bool) -> Void)? = nil){
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .authorized: actionOkButton!(true)
        case .restricted: actionOkButton!(false)
        case .denied: actionOkButton!(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
               
                if granted {
                    actionOkButton!(true)
                }else {
                    actionOkButton!(false)
                }
            })
        }
    }
    
    func accessToPhotos(actionOkButton: ((_ isOk: Bool) -> Void)? = nil){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: actionOkButton!(true)
        case .restricted: actionOkButton!(false)
        case .denied: actionOkButton!(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                    actionOkButton!(true)
                }else {
                    actionOkButton!(false)
                }
            })
        default:
            break 
        }
    }
    
    func accessToAudio(actionOkButton: ((_ isOk: Bool) -> Void)? = nil){
        let microPhoneStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        
        switch microPhoneStatus {
        case .authorized:
            return actionOkButton!(true)
        case .denied:
            return actionOkButton!(false)
        case .restricted:
            return actionOkButton!(false)
        case .notDetermined:
            
            AVAudioSession.sharedInstance().requestRecordPermission({ (isGranted) in
                
                return actionOkButton!(isGranted)
            })
            
        }
    }
    
    
    
    func showAlertWithConfirm(title : String?, message : String? , btnLeftTitle : String?,btnRightTitle: String? ,actionOkButton: ((_ isOk: Bool) -> Void)? = nil){
        
        
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: btnLeftTitle, style: UIAlertAction.Style.cancel,  handler: { action in
            
            actionOkButton!(false)
         }))
        
        
        alert.addAction(UIAlertAction(title: btnRightTitle, style: UIAlertAction.Style.`default`, handler: { action in
            
            actionOkButton!(true)
            
            
        }))
        
        alert.view.tintColor = UIColor.ColorApp
        
        ez.runThisInMainThread {
            ez.topMostVC?.presentVC(alert)
        }
    }
   
}
