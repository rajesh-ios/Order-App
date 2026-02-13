
//
//  ProfileViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/22/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
//import EZSwiftExtensions

class ProfileViewController: BaseViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var lblName : UILabel?
    @IBOutlet weak var lblEmailAddress : UILabel?
    @IBOutlet weak var imgPhoto : UIImageView?
    @IBOutlet weak var lblVersion : UILabel?
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    //MARK::- VARIABLES
    var optionArr = Arrays.ProfileOptions.get()
    var walletAmt : String?
    var referalCode : String?
    
    //MARK::- LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        self.view.addSubview(faButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWalletAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUserDetails()
    }
    
    func onViewDidLoad() {
        //configureTableView()
      //  tableView.tableFooterView = UIView()
        if let version = ez.appVersion{
            lblVersion?.text = "Version : \(version)"
        }
       
    }
    
    
    func setUpUserDetails() {
        if let modal = UDKeys.UserDTL.fetch() as? UserDetails {
            lblName?.text = modal.name
            lblEmailAddress?.text = modal.mobno
            referalCode = modal.referalCode
            let remove = modal.imagePath?.replace(target: "/DoDooUAT", withString: "")
            avatarView.imageName = remove
        }
    }
    
    
    //MARK: - ConfigureTableView
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: optionArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.reuseIdentifier.profileOptionCell.identifier)
        
        tableDataSource?.configureCellBlock = {[weak self](cell, item, indexpath) in
            
            guard let self = self else {return}
            guard let item = item as? String else {return}
            (cell as? ProfileOptionCell)?.walletAmt = self.walletAmt
            (cell as? ProfileOptionCell)?.index = indexpath?.row
            (cell as? ProfileOptionCell)?.model = item
        }
        
        tableDataSource?.aRowSelectedListener = {[weak self](indexpath,cell) in
            
            guard let self = self else {return}
            self.didSelect(indexpath : indexpath)
        }
    }
    
    
    func didSelect(indexpath : IndexPath){
        switch indexpath.row {
        case 0:
            guard let vc = R.storyboard.main.accountDetailsViewController() else {
                return
            }
            self.pushVC(vc)
            
        //My Addresses
        case 1:
            guard let vc = R.storyboard.main.myAddressesViewController() else {
                return
            }
            self.pushVC(vc)
            break
        case 2:
            break
        case 3:
            shareTheiOSApp()
            
        case 4,5:
            guard let vc = R.storyboard.main.supportFeedbackViewController() else {
                return
            }
            vc.module = indexpath.row == 4 ? .Support : .Feedback
            self.pushVC(vc)
            break
        case 6:
            guard let vc = R.storyboard.main.changePasswordViewController() else {
                return
            }
            vc.module = .ChangePassword
            self.pushVC(vc)
        case 7:
            self.logoutPressed()
        default:
            break
            
        }
    }
    
    func shareTheiOSApp() {
        
        let objectsToShare = ["Register on Dodoo with \(/referalCode) and earn Rs.50/- cashback. Use Promo Code REF50 while ordering.\nAndroid app \(APIConstants.dodooAppPlaystorelink)\niOS App \(APIConstants.dodooAppLink)"] as [Any]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        ez.topMostVC?.present(activityVC, animated: true, completion: nil)
    }
    
}


extension ProfileViewController {
    
    func logoutPressed(){
        
        AlertsClass.shared.showAlertController(withTitle: R.string.localize.logout(), message: R.string.localize.logoutSure() ,buttonTitles : [R.string.localize.ok(),R.string.localize.cancel()]) {(value) in
            let type = value as AlertTag
            switch type {
            case .yes:
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.logout()
            default : return
            }
        }
    }
    
}



//MARK API TO GET THE WALLET AMOUNT
extension ProfileViewController {
    
    func getWalletAmount() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.getWalletInfo(userID: self.UserID)) { [weak self](response) in
            self?.handle(response: response)
        }
    }
    
    
    func handle(response : Response){
        switch response {
        case .success(let obj):
            if let modal = obj as? String {
                walletAmt = modal
                configureTableView()
            }
        default:
            break
        }
        Utility.shared.stopLoader()
    }
}
