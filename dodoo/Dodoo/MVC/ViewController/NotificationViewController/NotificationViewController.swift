//
//  NotificationViewController.swift
//  Dodoo
//
//  Created by Shubham on 21/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation

class NotificationViewController: BaseViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    var notificationArr  = [NotificationModal]()
    var isFirstTime : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        getNotifications()
    }
}


extension NotificationViewController {
    
    func getNotifications() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: LoginEndpoint.getNotification(userID: UserID)) { [weak self](response) in
            self?.handleResponse(response : response)
        }
    }
    
    func handleResponse(response : Response){
        
        switch response {
        case .success(let obj):
            if let modal = obj as? [NotificationModal] {
                self.notificationArr = modal
                
                if self.notificationArr.count > 0 {
                    
                    noDataLabel.isHidden = true
                }
                reloadTable()
            }
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
        
        Utility.shared.stopLoader()
    }
}



extension NotificationViewController {
    
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: notificationArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.reuseIdentifier.notificationCell.identifier)
        
        tableDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? NotificationCell)?.modal = item
        }
    }
    
    func reloadTable() {
        if isFirstTime {
            self.isFirstTime = false
            configureTableView()
        }
        else {
            tableDataSource?.items = self.notificationArr
            tableView?.reloadData()
        }
    }
}
