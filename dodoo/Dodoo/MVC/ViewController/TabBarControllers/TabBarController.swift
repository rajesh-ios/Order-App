//
//  TabBarController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/3/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions
import Foundation

class TabBarController: UITabBarController {
    
    
    @IBOutlet weak var tabbar : UITabBar!
    
    var btnClicked : Bool    = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let Tabbar = tabbar , let item = Tabbar.items?[0] {
            setBackgroundOnSelectTabBarItem(Tabbar , item)
        }
        checkAppVersion()
    }
}


extension TabBarController {
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setBackgroundOnSelectTabBarItem(tabBar, item)
    }
    
    func setBackgroundOnSelectTabBarItem(_ tabBar : UITabBar , _ item : UITabBarItem){
        let removeSelectedBackground = {
            tabBar.subviews.filter({ $0.layer.name == "TabBackgroundView" }).first?.removeFromSuperview()
        }
        
        let addSelectedBackground = { (bgColour: UIColor) in
            let tabIndex = CGFloat(tabBar.items!.index(of: item)!)
            let tabWidth = tabBar.bounds.width / CGFloat(tabBar.items!.count)
            let bgView = UIView(frame: CGRect(x: tabWidth * tabIndex, y: 0, width: tabWidth, height: tabBar.bounds.height))
            bgView.backgroundColor = bgColour
            bgView.layer.name = "TabBackgroundView"
            tabBar.insertSubview(bgView, at: 0)
        }
        
        removeSelectedBackground()
        if let color = UIColor.init(named: "#c7d538") {
            addSelectedBackground(color)
        }
    }
}


extension TabBarController {
    func checkAppVersion() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: LoginEndpoint.getAppVersion) { [weak self](response) in
            self?.handleVersionResponse(response)
        }
    }
    
    
    func handleVersionResponse(_ response : Response) {
        
        switch response {
        case .success(let obj):
            if let modal = obj as? VersionModal {
                guard let currentVersion = ez.appVersion , let normalVersion = modal.version  else {return}
                var normalVersionNumber = normalVersion.replace(target: ".", withString: "")
//                var normalVersionNumber = "201"
                var currentVersionNumber = currentVersion.replace(target: ".", withString: "")
                print("normal version : \(/normalVersionNumber.toInt())")
                print("current version : \(/currentVersionNumber.toInt())")
                if /normalVersionNumber.toInt() > /currentVersionNumber.toInt() && normalVersionNumber.count == currentVersionNumber.count{
                    showAlert(title : R.string.localize.attention() ,description : R.string.localize.appUpdate() , isForceUpdate : false)
                }
                else if /normalVersion.first?.toString.compare(currentVersion.first!.toString).rawValue == 1 {
                    showAlert(title : R.string.localize.attention() ,description : R.string.localize.appUpdate() , isForceUpdate : false)
                }
                else if /normalVersion.first?.toString.compare(currentVersion.first!.toString).rawValue == 0 {
                    if normalVersionNumber.count == 2 {
                        normalVersionNumber.append("0")
                    }
                    if currentVersionNumber.count == 2 {
                        currentVersionNumber.append("0")
                    }
                    if /normalVersionNumber.toInt() > /currentVersionNumber.toInt() {
                        showAlert(title : R.string.localize.attention() ,description : R.string.localize.appUpdate() , isForceUpdate : false)
                    }
                    else {
                        ez.runThisInMainThread {
                            self.getNewOffers()
                        }
                    }
                }
                else {
                    ez.runThisInMainThread {
                        self.getNewOffers()
                    }
                }
            }
        case .failure(_):
            break
        }
        
    }
    
    func showAlert(title : String , description : String , isForceUpdate : Bool){
        AlertsClass.shared.showAlertController(withTitle: title, message: description, buttonTitles: [ R.string.localize.update()]) { (value) in
            let type = value as AlertTag
            switch type {
            default :
                self.startUpdate()
            }
        }
    }
    
    func startUpdate(){
        if self.btnClicked == false {
            self.checkAppVersion()
        }
        guard let urlStr = URL(string: APIConstants.dodooAppLink) else {return}
        UIApplication.shared.open(urlStr)
    }
    
    func cancelUpdate() {
        self.btnClicked = true
        return
    }
    
    
}


extension TabBarController {
    
    func getNewOffers() {
        APIManager.shared.request(with: HomeEndpoint.getOffers) { [weak self](response) in
            self?.handle(response : response)
        }
    }
    
    func handle(response : Response){
        
        switch response {
        case .success(let obj):
            if let modal = obj as? [GetOffersModal] , let newOffer = modal.first{
                if let url = newOffer.imagePath {
                    let image = UIImage.init(url: URL(string: url))
                    if image != nil {
                         openNewOffersVC(image: image)
                    }
                }
            }
            
        case .failure(_):
            break
        }
    }
    
    func openNewOffersVC(image : UIImage?) {
        guard let vc = R.storyboard.main.newOffersViewController() else {
            return
        }
        vc.getImage = image
        self.present(vc, animated: false) {
            
            Utility.shared.stopLoader()
        }
    }
}
