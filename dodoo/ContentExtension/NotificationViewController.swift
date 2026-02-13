//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Apple on 06/07/21.
//  Copyright © 2021 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
let kImageKey = "gcm.notification.imageUrl"

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    //MARK::- OUTLETS
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var lbldescription : UILabel?
    @IBOutlet weak var imageView : UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func didReceive(_ notification: UNNotification) {
        self.lblTitle?.text = notification.request.content.title
        self.lbldescription?.text = notification.request.content.body
        let content = notification.request.content

        if let urlImageString = content.userInfo[kImageKey] as? String {
            if let url = URL(string: urlImageString) {
                URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                    if let _ = error {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.imageView?.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
}

extension URLSession {
    
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}


