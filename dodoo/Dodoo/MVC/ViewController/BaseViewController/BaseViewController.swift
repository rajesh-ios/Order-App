//
//  BaseViewController.swift
//  RedVault
//
//  Created by Shubham Dhingra on 17/12/18.
//  Copyright © 2017 Shubham . All rights reserved.
//

import UIKit
//import EZSwiftExtensions

protocol ChangeChildDelegate {
    func changeVC(VC : UIViewController?)
    func managementChangeVC()
}
let kRazorPayPaymentGateway = "Razor Pay"
let kCashFreePaymentGateway = "Cashfree"

typealias successBlock = (_ result: AnyObject? ) -> ()

class BaseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var btnTermsAndCond: UIButton?
    @IBOutlet weak var topHeaderConstraint: NSLayoutConstraint?
    
    var name : String?
    var step : Int?
    
    struct GlobalContainer{
        static var container = UIView()
    }
    
    var UserID : String {
        if let userDTL = UDKeys.UserDTL.fetch() as? UserDetails , let userID = userDTL.id {
            return userID
        }
        return ""
    }
    
    var tableDataSource : TableViewDataSource?{
        didSet{
            
            tableView?.dataSource = tableDataSource
            tableView?.delegate = tableDataSource
            tableView?.reloadData()
        }
    }
    
    var collectionDataSource: CollectionViewDataSource?{
        didSet{
            collectionView?.dataSource = collectionDataSource
            collectionView?.delegate = collectionDataSource
            collectionView?.reloadData()
        }
    }
    
    lazy var faButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: UIScreen.main.bounds.width / 1.25, y: UIScreen.main.bounds.height / 1.22, width: 60, height: 60)
        btn.setImage(UIImage(named: "whatsapp"), for: .normal)
        btn.addTarget(self, action: #selector(floatingButtonClicked), for:.touchUpInside)
        btn.backgroundColor = UIColor.black
        btn.shadowRadiu = 4
        btn.shadowOffse = CGSize(width: 1, height: 1)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 28
        
        return btn
    }()
    
    var xibToLoad : UINib? {
        didSet {
            loadViewXIb()
        }
    }
    //    var activeViewController: UIViewController? {
    //        didSet {
    //            removeInactiveViewController(oldValue)
    //            updateActiveViewController()
    //        }
    //    }
    //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpForIphoneX()
//        self.view.addSubview(faButton)
    }
    
    func handleResponse(response : Response, responseBack : successBlock) {
        switch response{
            
        case .success(let responseValue):
            responseBack(responseValue)
            
        case .failure(let msg):
            Messages.shared.show(alert: .oops, message: /msg, type: .warning)
        }
    }
    
    deinit {
        
        print("deinit base view controller")
    }
}

extension BaseViewController {
    
    @IBAction func btnNotifications(_ sender: UIButton) {
        guard let vc = R.storyboard.home.notificationViewController() else {
            return
        }
        self.pushVC(vc)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController == nil ? dismissVC(completion: nil) : popVC()
    }
    
    @IBAction func btnSideMenu(_ sender: UIButton) {
        //        if let container = self.so_containerViewController{
        //            container.isSideViewControllerPresented = true
        //        }
    }
    
    @IBAction func btnTermsAndCond(_ sender: UIButton) {
        //        sender.currentImage == R.image.ic_rect() ? sender.setImage(R.image.ic_fill_rect(), for: .normal) : sender.setImage(R.image.ic_rect(), for: .normal)
    }
    
    @IBAction func btnYesAct(_ sender: UIButton) {
        
    }
    
    @IBAction func btnNoAct(_ sender: UIButton) {
        
    }
    
    @IBAction func btnAddArabicLang(_ sender: UIButton) {
        
    }
    
    @objc func floatingButtonClicked() {
        
        WhatsAppManager.shared.openWhatsapp()
    }
}

extension BaseViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
}

extension BaseViewController {
    func setUpForIphoneX() {
        
        if ez.topMostVC is SignUpViewController {
            topHeaderConstraint?.constant = isiPhoneXSeries ? 30.0 : 16.0
        }
        else if ez.topMostVC is ProfileViewController || ez.topMostVC is ScheduleViewController || ez.topMostVC is HotDealsViewController || ez.topMostVC is OrderDetailsViewController || ez.topMostVC is OrderViewController {
            topHeaderConstraint?.constant = isiPhoneXSeries ? 40.0 : 20.0
        }
        else {
            topHeaderConstraint?.constant = isiPhoneXSeries ? 84.0 : 64.0
        }
    }
    
    
    //Height = 2436 for iphoneX, iphoneXS
    //Height = 2688 for iphoneXS Max
    //Height = 1792 for iphoneXR
    
    
    private var isiPhoneXSeries : Bool {
        return UIScreen.main.nativeBounds.size.height == 2436 || UIScreen.main.nativeBounds.size.height == 2688 || UIScreen.main.nativeBounds.size.height == 1792 || ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0)
    }
}

//MARK: ---- Container Driven Methods
//extension BaseViewController {
//
//    fileprivate func removeInactiveViewController(_ inactiveViewController: UIViewController?) {
//        if let inActiveVC = inactiveViewController {
//            inActiveVC.willMove(toParentViewController: nil)
//            inActiveVC.view.removeFromSuperview()
//            inActiveVC.removeFromParentViewController()
//        }
//    }
//
//    fileprivate func updateActiveViewController() {
//
//        if let activeVC = activeViewController {
//            addChildViewController(activeVC)
//            activeVC.view.frame = containerView?.bounds ?? .zero
//            containerView?.addSubview(activeVC.view)
//            activeVC.didMove(toParentViewController: self)
//        }
//    }
//
//}

extension BaseViewController {
    
    fileprivate func loadViewXIb(){
        if let loadXIb = xibToLoad ,let parent = self.parent{
            let view = loadXIb.instantiate(withOwner: nil , options: nil)[0] as! UIView
            view.frame = parent.view.bounds
            parent.view.addSubview(view)
            //            view.showAnimate()
        }
    }
    
    
    func animated(){
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}


extension BaseViewController {
    func hitAPI(pickUpModal : PickUpDropModal , module  : Module? , paymentId : String? , paymentErroCodeDesc : String? , paymentGateway : String? = kRazorPayPaymentGateway, isLoader: Bool) {
        guard let selModule = module else {
            return
        }
        
        if isLoader {
            
            Utility.shared.startLoader()
        }
        
        APIManager.shared.request(with: LoginEndpoint.saveSubscriptionAndPickUpDrop(module: selModule, details: pickUpModal.toJSON()), isLoader: true) { [weak self](response) in
            self?.handle(response : response , module:  selModule , isOnlinePaymentMode :  pickUpModal.paymentMode == "Online Payment" , paymentId : paymentId , paymentErrorCodeDesc : paymentErroCodeDesc, paymentGateway: /paymentGateway)
        }
    }
    
    
    func handle(response : Response , module : Module , isOnlinePaymentMode : Bool , paymentId : String? , paymentErrorCodeDesc : String? = "" , paymentGateway : String){
        switch response {
        case .success(let object):
            if let response = object as? RegisterModal {
                if response.Status == "1" {
                    if module == .Subscription {
                        Messages.shared.show(alert: .success, message: R.string.localize.saveSubscriptionSuccess(), type: .success)
                        Utility.shared.stopLoader()
                    }
                    else {
                        if isOnlinePaymentMode {
                            if paymentGateway == kCashFreePaymentGateway {
//                                (ez.topMostVC as? PaymentViewController)?.getUpdateOrderId(orderId: /response.Result)
                                (ez.topMostVC as? PaymentViewController)?.forPickUpAndDrop = true
                                (ez.topMostVC as? PaymentViewController)?.getCashFreeToken(orderId: /response.Result)
                                
                            }
                            else {
                                if paymentId?.count != 0 {
                                    Messages.shared.show(alert: .success, message: R.string.localize.orderPlacedSuccess() , type: .success)
                                    if isOnlinePaymentMode {
                                        let paymentStatus = paymentId?.count != 0 ? "Success" : "Failure"
                                        let updateOrderId = (ez.topMostVC as? PaymentViewController)?.getUpdateOrderId(orderId: /response.Result)
                                        
                                        orderPaymentInfo(orderId: /updateOrderId, paymentId: paymentId ?? "", orderType: module.id, paymentStatus: paymentStatus, errorCode: paymentErrorCodeDesc, paymentGateWay: kRazorPayPaymentGateway)
                                    }
                                }
                            }
                           
                        }
                        else {
                            Messages.shared.show(alert: .success, message: R.string.localize.orderPlacedSuccess() , type: .success)
                        }
                    }
                    
                    
                    if module == .Subscription {
                        self.popVC()
                    }
                    else {
                        if isOnlinePaymentMode {
                            if paymentId?.count != 0 {
                                self.navigateToRoot()
                            }
                        }
                        else {
                          self.navigateToRoot()
                        }
                    }
                    
                }
                else {
                    
                    Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong() , type: .warning)
                    Utility.shared.stopLoader()
                }
                
            }
            break
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong() , type: .warning)
            Utility.shared.stopLoader()
            break
        }
    }
    
    func navigateToRoot() {
        guard let viewcontrollers = self.navigationController?.viewControllers else {
            return
        }
        for (_,vc) in viewcontrollers.enumerated() {
            if vc is TabBarController {
                (vc as? TabBarController)?.selectedIndex = 0
                self.navigationController?.popToViewController(vc, animated: false)
                break
            }
        }
    }
   
}


extension BaseViewController {
    
    
    func orderPaymentInfo(orderId : String , paymentId : String , orderType : String? , paymentStatus : String? , errorCode : String? , paymentGateWay : String? , paymentMode : String? = "") {
        let transDate = Date().dateConvert(time: Date(), format: DateFormat.date1.id)
        let paymentModal = PaymentModal(orderID_: orderId, orderType_: orderType, paymentID_: paymentId, paymentStatus_: paymentStatus, errorCode_: errorCode, transDate_: transDate , PaymentGateWay_: paymentGateWay ,paymentMode_ : paymentMode)
        APIManager.shared.request(with: HomeEndpoint.orderPaymentInfo(paymentInfo: paymentModal.toJSON()), isLoader: false) { (response) in
            
            Utility.shared.stopLoader()
        }
    }
}


extension BaseViewController {
    
    
}
