//
//  AppDelegate.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/7/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseMessaging
import UserNotifications
import SwiftyJSON
//import EZSwiftExtensions


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate ,MessagingDelegate{

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var userInfo : JSON?
//    let notificationDelegate = SampleNotificationDelegate()
    
    var openingAnotherApp = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        AIzaSyAQgQcQ8jYMTzVHLQOs25xaLkyienR4Lb4
        GMSPlacesClient.provideAPIKey("AIzaSyAQgQcQ8jYMTzVHLQOs25xaLkyienR4Lb4")
        GMSServices.provideAPIKey("AIzaSyAQgQcQ8jYMTzVHLQOs25xaLkyienR4Lb4")
        GIDSignIn.sharedInstance().clientID = "1054649290873-ghp256s5aln4bkoj3kp9a3fb5pfelfg3.apps.googleusercontent.com"
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        setupFireBase(application)
        DispatchQueue.main.async {
            LocationManager.shared.updateUserLocation()
        }
        
        StoreReviewHelper.incrementAppOpenedCount()
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
       

      if #available(iOS 13.0, *) {
                    // Always adopt a light interface style.
        self.window?.overrideUserInterfaceStyle = .light
      }
        
//        "AIzaSyBXSqpwZMusvu5KiWzEqZtWQWOx94j-7Vs"
        
        // Override point for customization after application launch.
        return true
    }
    
    func setupFireBase(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
//            let content = UNMutableNotificationContent()
//            content.sound = .default
//            content.title = "Shubham"
////            content.description = "Shubham is a good boy"
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//            let request = UNNotificationRequest(identifier: "Suggestion", content: content, trigger: trigger)
//            center.add(request, withCompletionHandler: nil)
//
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        connectToFcm()
    }
    
    
    // [START refresh_token]
    @objc func tokenRefreshNotification(_ notification: Notification) {
        connectToFcm()
    }
    
    // [END refresh_token]
    
    
    //MARK::- CONNECT TO FCM
    func connectToFcm() {
        // Won't connect since there is no token
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }
            else {
                if let result = result {
                    print("FCM Token = \(String(describing : result.token))")
                    UDKeys.FCMToken.save(result.token)
                }
                
//                print("FCM Token = \(String(describing: result?.token))")
                print("Remote instance ID token: \(/result?.token)")
               
            }
        }
        guard Messaging.messaging().fcmToken != nil else {
             return
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert , .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Received Notification")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        if UIApplication.shared.applicationState == .active  {
            
            //            if #available(iOS 10.0, *)  {
            //                handleNotifcation(userInfo: JSON(userInfo))
            //
            //            } else {
            //                //for IOS9 and below
            //                showNotification(userInfo: JSON(userInfo))
            //
            //      }
           // showToast(userInfo : JSON(userInfo))
            
        } else {
            //            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            //            DispatchQueue.main.asyncAfter(deadline: when) {
            self.handleNotifcation(userInfo: JSON(userInfo))
            //            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        
        print("Device Token = ", token)
        //        UDKeys.deviceToken.save(token)
        //For production
        //        InstanceID.instanceID().setAPNSToken
        Messaging.messaging().apnsToken = deviceToken
        //           InstanceID.instanceID().setAPNSToken(deviceToken as Data, type: .prod )
        
        //For Testing
        //  InstanceID.instanceID().setAPNSToken(deviceToken as Data, type: .sandbox )
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict: [String: String] = ["token": fcmToken]
          NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
          )
          // TODO: If necessary send token to application server.
          // Note: This callback is fired at each app startup and whenever a new token is generated.

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if openingAnotherApp == false {
            
            openingAnotherApp = true
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if openingAnotherApp == true {
            
            openingAnotherApp = false
            
            let clLocationManger = CLLocationManager()
            
            clLocationManger.requestWhenInUseAuthorization()
            
            let status = CLLocationManager.authorizationStatus()
            
            switch status {
            case .authorizedWhenInUse,.authorizedAlways: break
            case .notDetermined:
                LocationManager.shared.callUserAuthorization()
            case .restricted,.denied:
                LocationManager.shared.settingsAlert()
            }
            
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Utility.shared.startLoader()
//        if FBSDKApplicationDelegate.sharedInstance.application(app, open: url, options: options){return true}
        ApplicationDelegate.shared.application(
                    app,
                    open: url,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                )
        
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]){return true}
        
        return true
    }
    
    
    func logout(){
        UDKeys.AccessToken.remove()
        UDKeys.UserDTL.remove()
        
        guard let initialNavVC = R.storyboard.main.instantiateInitialViewController() else {return}
        guard  let VC = R.storyboard.main.loginViewController() else {return}
        initialNavVC.viewControllers = [VC]
        UIView.transition(with: UIApplication.shared.keyWindow!, duration: 0.5, options: .transitionFlipFromLeft , animations: { () -> Void in
            UIApplication.shared.keyWindow?.rootViewController = initialNavVC
            // self.so_containerViewController?.topViewController = initialNavVC
        }) { (completed) -> Void in
        }
    }

}

extension AppDelegate{
    //MARK::- SHOW CUSTOM NOTIFICATION
    func showNotification(userInfo : JSON) {
        //        let obj = ISMessages.cardAlert(withTitle: "Spotlight", message: userInfo["title"].stringValue, iconImage: nil, duration: 2.0, hideOnSwipe: true, hideOnTap: false, alertType: .custom, alertPosition: .top)
        //
        //        let tapToOpen = UITapGestureRecognizer(target: self, action:  #selector(self.tappedOnNotification(_:)))
        //
        //        obj?.alertViewBackgroundColor = UIColor.yelow()
        //        obj?.view.addGestureRecognizer(tapToOpen)
        //
        //        obj?.show(nil, didHide: nil)
        //
        ////        ez.dispatchDelay(2.0, closure: {
        ////            ISMessages.hideAlert(animated: true)
        ////        })
        
    }
    
    //MARK::- Token Refresh Api
    
    
    //MARK: - Tap on IOS9 notification action
    func tappedOnNotification(_ sender: UIGestureRecognizer) {
        guard let data = userInfo else { return }
        handleNotifcation(userInfo: data)
    }
    
    //MARK::- HANDLE PUSH
    func handleNotifcation(userInfo : JSON) {
        ez.runThisInMainThread {
            guard let vc = R.storyboard.home.storeViewController() else {
                return
            }
            //        vc.advertisementArr = advertisementArr
            ez.topMostVC?.pushVC(vc)
        }
       
    }
}




