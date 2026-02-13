//
//  StoreReviewHelper.swift
//  Dodoo
//
//  Created by Banka Rajesh on 07/09/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    
    static func incrementAppOpenedCount() {
        guard var appOpenCount = UDKeys.APP_OPENED_COUNT.fetch() as? Int else {
            UDKeys.APP_OPENED_COUNT.save(1)
            return
        }
        appOpenCount += 1
        UDKeys.APP_OPENED_COUNT.save(appOpenCount)
    }
    
    static func checkAndAskForReview() {
        
        guard let appOpenCount = UDKeys.APP_OPENED_COUNT.fetch() as? Int else {
            UDKeys.APP_OPENED_COUNT.save(1)
            return
        }
        
        guard let lastVersionPromptedForReview = UDKeys.lastVersionPromptedForReviewKey.fetch() as? String else {
            
            UDKeys.lastVersionPromptedForReviewKey.save("0")
            return
        }
        
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }

        // Has the process been completed several times and the user has not already been prompted for this version?
        if appOpenCount >= 20 && (currentVersion != lastVersionPromptedForReview) {
            
            StoreReviewHelper().requestReview()
            UDKeys.lastVersionPromptedForReviewKey.save(currentVersion)
            UDKeys.APP_OPENED_COUNT.save(0)
        }
        
    }
    
    func requestReview() {
        
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
        else {
            SKStoreReviewController.requestReview()
        }
        
    }
    
    func requestReviewManually() {
        
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1456011773?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}

extension UIApplication {
    @available(iOS 13.0, *)
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
