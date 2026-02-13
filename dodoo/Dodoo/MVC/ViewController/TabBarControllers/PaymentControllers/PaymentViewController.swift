
//
//  PaymentViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/5/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import CFSDK
import ObjectMapper
import SwiftyJSON
//import EZSwiftExtensions

let kNotesLbl = "Notes to store or delivery partner(Optional)"
let kminimumCartValueWalletError = "Minimum Rs.@ cart value required to use wallet amount";
let kminimumCartValueCouponError = "Minimum cart amount should be greater than Rs.@";

//Cashfree

/*Testing Server*/
//let kAppID = "109369e5cb237ff5ea8ff5d1b6963901"
//let kEnv = "TEST"

/*Production Server*/
let kAppID = "156193f90f648d5cad52514c21391651"
let kEnv = "PROD"

enum CashFreePaymentStatus : String {
    case success = "SUCCESS"
    case failure = "FAILURE"
    case cancelled = "CANCELLED"
}

let MIN_PRICE_FOR_WALLET_USED = 300
let MIN_PRICE_FOR_COUPON_USED = 300

class PaymentViewController : BaseViewController {
    
//    @IBOutlet weak var btnOnlinePayment : UIButton?
//    @IBOutlet weak var btnCashfree : UIButton?
//    @IBOutlet weak var btnOfflinePayment : UIButton?
    @IBOutlet weak var btnSubmit : UIButton?
    @IBOutlet weak var txtPromoCode : UITextField?
    @IBOutlet weak var btnApply : UIButton?
    @IBOutlet weak var lblCodeSuccessMsg : UILabel?
    
    @IBOutlet weak var lblPrice : UILabel?
    @IBOutlet weak var lblTax : UILabel?
    @IBOutlet weak var lblDeliveryCharges : UILabel?
    @IBOutlet weak var lblPromoCode : UILabel?
    
    @IBOutlet weak var lblTotal : UILabel?
    @IBOutlet weak var lblRoundTotal : UILabel?
    
    @IBOutlet weak var lblWallet : UILabel?
    @IBOutlet weak var viewPrice : UIView?
    @IBOutlet weak var btnWalletSelect : UIButton?
    
    @IBOutlet weak var viewPromoCode : UIView?
    @IBOutlet weak var viewWallet : UIView?
    @IBOutlet weak var viewPromoCodeCalculation : UIView?
    @IBOutlet weak var lblWalletDeductAmt : UILabel?
    @IBOutlet weak var lblDeliveryDistance : UILabel?
    @IBOutlet weak var viewDeliveryDistance : UIView?
    
    @IBOutlet weak var txtNotes : UITextField?
    @IBOutlet weak var viewNotes : UIView?
    @IBOutlet weak var lblDeliveryChargesLabel : UILabel?
    @IBOutlet weak var priceView : UIView?
    @IBOutlet weak var selectedCouponLabel: UILabel!
    @IBOutlet weak var viewAll: UIButton!
    @IBOutlet weak var walletViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var gPayStack: UIStackView!
    @IBOutlet weak var phonePeStack: UIStackView!
    @IBOutlet weak var paytmStack: UIStackView!
    @IBOutlet weak var cashStack: UIStackView!
    @IBOutlet weak var cardStack: UIStackView!
    
    @IBOutlet weak var gPayRadioImage: UIImageView!
    @IBOutlet weak var phonePeRadioImage: UIImageView!
    @IBOutlet weak var paytmRadioImage: UIImageView!
    @IBOutlet weak var cashRadioImg: UIImageView!
    @IBOutlet weak var cardNetRadioImg: UIImageView!
    
   
    
    @IBOutlet weak var buttonPhonePe: UIButton!
    @IBOutlet weak var buttonPaytm: UIButton!
    @IBOutlet weak var buttonGPay: UIButton!
    
    @IBOutlet weak var buttonCard: UIButton!
//    @IBOutlet weak var buttonProceed: UIButton!
    @IBOutlet weak var buttonCash: UIButton!
    
    @IBOutlet weak var noUPIAppsLabel: UILabel!
    @IBOutlet weak var couponWalletNoteView: UIView!
    @IBOutlet weak var upiStack: UIStackView!
    @IBOutlet weak var creditCashStack: UIStackView!
    @IBOutlet weak var couponLabelGlow: UILabel!
    @IBOutlet weak var navigationHeaderTitle: UILabel!
    
    var selectedCoupon: GetOffersModal?
    
    var totalCost : Int?
    var storeOrderModal : StoreOrdersModal?
    var storeModal : StoresModal?
    var pickUpDropModal : PickUpDropModal?
    var tax : Double?
    var pricePerKm : Double?
    var walletAmt : Double?
    var walletAmtUsed : Double = 0.0
    var distanceCalculated : Double?
    var sourcePoint : MKMapPoint?
    var destinationPoint : MKMapPoint?
    var totalTax , totalDeliveryCost : Double?
    var totalPrice : Double?
    var totalPromoCodeValue : Double? = 0.0
    var forPickUpAndDrop : Bool? = false
    var getOffersModal = [GetOffersModal]()
    var paymentId : String?
    var paymentErroCodeDesc : String?
    var deliveryChargesFromAPI : Double?
    var orderId : String?
    var paymentFromPickupDrop: Bool = false
    
    var selectedUPI: CFUPIApp?
    var upiPayment: Bool = false
    var cashFreeSelected: Bool = false
    
    var upiCount: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        couponLabelGlow.doGlowAnimation()
        buttonGPay.isHidden = true
        buttonPhonePe.isHidden = true
        buttonPaytm.isHidden = true
        buttonCash.isHidden = true
        buttonCard.isHidden = true
        
        tapGestureFunctionality()
        
        phonePeStack.isHidden = !isAppInstalled("phonepe")
        gPayStack.isHidden = !isAppInstalled("tez")
        paytmStack.isHidden = !isAppInstalled("paytm")
        
        if upiCount == 0 {
            
            upiStack.spacing = 10
            noUPIAppsLabel.isHidden = false
        }
        else {
            
            noUPIAppsLabel.isHidden = true
        }
    }
    
    func isAppInstalled(_ appName:String) -> Bool{

        let appScheme = "\(appName)://app"
        let appUrl = URL(string: appScheme)

        if UIApplication.shared.canOpenURL(appUrl! as URL){
            return true
        } else {
            upiCount -= 1
            upiStack.spacing -= 10
            return false
        }
    }
    
    func tapGestureFunctionality() {
        
        let gpay = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        let phonePe = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        let paytm = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        let cash = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        let card = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        
        
        
        self.gPayStack.isUserInteractionEnabled = true
        self.gPayStack.addGestureRecognizer(gpay)
        
        self.phonePeStack.isUserInteractionEnabled = true
        self.phonePeStack.addGestureRecognizer(phonePe)
        
        self.paytmStack.isUserInteractionEnabled = true
        self.paytmStack.addGestureRecognizer(paytm)
        
        self.cardStack.isUserInteractionEnabled = true
        self.cardStack.addGestureRecognizer(card)
        
        self.cashStack.isUserInteractionEnabled = true
        self.cashStack.addGestureRecognizer(cash)
    }
    
    @objc func hidingButton_imageChange(_ sender: UITapGestureRecognizer) {
        
        guard let tag = sender.view?.tag else { return }
        
        cashFreeSelected = false
        upiPayment = true
        
        switch tag {
            
        case 0:
            
            if buttonGPay.isHidden {
                
                buttonGPay.isHidden = false
                buttonPhonePe.isHidden = true
                buttonPaytm.isHidden = true
                buttonCard.isHidden = true
                buttonCash.isHidden = true
                
                gPayRadioImage.image = UIImage(named: "radio_btn_filled")
                phonePeRadioImage.image = UIImage(named: "radio_button_unfilled")
                paytmRadioImage.image = UIImage(named: "radio_button_unfilled")
                cashRadioImg.image = UIImage(named: "radio_button_unfilled")
                cardNetRadioImg.image = UIImage(named: "radio_button_unfilled")
            }
            
            else {
                
                defaultData()
            }
            
            
            break
            
        case 1:
            
            if buttonPhonePe.isHidden {
                
                buttonGPay.isHidden = true
                buttonPhonePe.isHidden = false
                buttonPaytm.isHidden = true
                buttonCard.isHidden = true
                buttonCash.isHidden = true
                
                gPayRadioImage.image = UIImage(named: "radio_button_unfilled")
                phonePeRadioImage.image = UIImage(named: "radio_btn_filled")
                paytmRadioImage.image = UIImage(named: "radio_button_unfilled")
                cashRadioImg.image = UIImage(named: "radio_button_unfilled")
                cardNetRadioImg.image = UIImage(named: "radio_button_unfilled")
            }
            else {
                
                defaultData()
            }
            
            break
            
        case 2:
            
            if buttonPaytm.isHidden {
                
                buttonGPay.isHidden = true
                buttonPhonePe.isHidden = true
                buttonPaytm.isHidden = false
                buttonCard.isHidden = true
                buttonCash.isHidden = true
                
                gPayRadioImage.image = UIImage(named: "radio_button_unfilled")
                phonePeRadioImage.image = UIImage(named: "radio_button_unfilled")
                paytmRadioImage.image = UIImage(named: "radio_btn_filled")
                cashRadioImg.image = UIImage(named: "radio_button_unfilled")
                cardNetRadioImg.image = UIImage(named: "radio_button_unfilled")
       
            }
            else {
                
                defaultData()
            }
        
            break
            
        case 3:
            
            if buttonCard.isHidden {
                
                buttonGPay.isHidden = true
                buttonPhonePe.isHidden = true
                buttonPaytm.isHidden = true
                buttonCard.isHidden = false
                buttonCash.isHidden = true
                
                gPayRadioImage.image = UIImage(named: "radio_button_unfilled")
                phonePeRadioImage.image = UIImage(named: "radio_button_unfilled")
                paytmRadioImage.image = UIImage(named: "radio_button_unfilled")
                cashRadioImg.image = UIImage(named: "radio_button_unfilled")
                cardNetRadioImg.image = UIImage(named: "radio_btn_filled")
            }
            else {
                
                defaultData()
            }
        
            break
            
        case 4:
            
            if buttonCash.isHidden {
                
                buttonGPay.isHidden = true
                buttonPhonePe.isHidden = true
                buttonPaytm.isHidden = true
                buttonCard.isHidden = true
                buttonCash.isHidden = false
                
                gPayRadioImage.image = UIImage(named: "radio_button_unfilled")
                phonePeRadioImage.image = UIImage(named: "radio_button_unfilled")
                paytmRadioImage.image = UIImage(named: "radio_button_unfilled")
                cashRadioImg.image = UIImage(named: "radio_btn_filled")
                cardNetRadioImg.image = UIImage(named: "radio_button_unfilled")
       
            }
            else {
                
                defaultData()
            }
        
            break
            
        default:
            defaultData()
            
        }
    }
    
    func defaultData() {
        
        buttonGPay.isHidden = true
        buttonPhonePe.isHidden = true
        buttonPaytm.isHidden = true
        buttonCard.isHidden = true
        buttonCash.isHidden = true
        
        gPayRadioImage.image = UIImage(named: "radio_button_unfilled")
        phonePeRadioImage.image = UIImage(named: "radio_button_unfilled")
        paytmRadioImage.image = UIImage(named: "radio_button_unfilled")
        cashRadioImg.image = UIImage(named: "radio_button_unfilled")
        cardNetRadioImg.image = UIImage(named: "radio_button_unfilled")

    }
    
    func onViewDidLoad() {
        
        txtPromoCode?.delegate = self
        getWalletAmount()
        //tax calculation
        priceCalculation()
        viewPromoCode?.isHidden = /forPickUpAndDrop
        viewWallet?.isHidden = /forPickUpAndDrop
        viewPromoCodeCalculation?.isHidden = /forPickUpAndDrop
        btnSubmit?.isExclusiveTouch = true
        lblWalletDeductAmt?.text = ""
        viewNotes?.isHidden = /forPickUpAndDrop
        couponWalletNoteView.isHidden = /forPickUpAndDrop
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.btnViewOffersAct(_:)))
    
        self.selectedCouponLabel.addGestureRecognizer(labelTap)
        
        self.lblWalletDeductAmt?.isHidden = true
        
        setUpUI()
    }
    
    func setUpUI() {
        if /forPickUpAndDrop  {
            cashStack.isHidden = true
        }
        else {
        if let modal = self.storeModal {
            
            if let coupons = modal.storecoupons {
                
                if coupons.count > 0 {
                    
                    viewAll.isHidden = false
                }
                else {
                    
                    viewPromoCode?.isHidden = true
                    viewAll.isHidden = true
                }
            }
            else {
                
                viewPromoCode?.isHidden = true
            }
            if let isCODAllow = modal.cod {
                cashStack.isHidden = !(isCODAllow && (/self.totalPrice < 500))
                creditCashStack.spacing = !(isCODAllow && (/self.totalPrice < 500)) ? 0 : 20
            }
            if let isOnlinePaymentAllow = modal.online {
                cardStack.isHidden = !isOnlinePaymentAllow
            }
        }
        }
       
    }
    
    func byDefaultWalletEnabled() {
        if walletAmt == 0.0 {
            btnWalletSelect?.isSelected = false
            return
        }
        btnWalletSelect?.isSelected = self.isWalletMoneyAllowed() && walletAmt != 0.0
        priceCalculation()
        lblWalletDeductAmt?.isHidden = !(/btnWalletSelect?.isSelected)
        lblWalletDeductAmt?.text = R.string.localize.walletDeductAmt(self.walletAmtUsed.toString)
    }
    
    func getWalletAmount() {
        APIManager.shared.request(with: HomeEndpoint.getWalletInfo(userID: self.UserID)) { [weak self](response) in
            self?.handle(response: response)
        }
    }
    
    @IBAction func btnViewOffersAct(_ sender : UIButton){
        
        if viewAll.isHidden {
            
            Messages.shared.show(alert: .oops, message: "No coupons available for this store", type: .warning)
        }
        else {
            
            if viewAll.titleLabel?.text == "View All" {
                
                Utility.shared.startLoader()
                self.getOffersModal.count == 0 ? getNewOffers() : navigateToCouponVC()
            }
            else {
                
                viewAll.setTitle("View All", for: .normal)
                selectedCouponLabel.textColor = .darkGray
                selectedCouponLabel.text = "Select a coupon"
                totalPromoCodeValue = 0.0
                lblPromoCode?.text = String(totalPromoCodeValue!)
                priceCalculation()
                
            }
            
        }
        
    }
    @IBAction func cardAndNetbankingPayment(_ sender: UIButton)
    {
        
        cashFreeSelected = true
        upiPayment = false
        var storeModal : StoreOrdersModal?
        
        if let modal = self.storeOrderModal {
            storeModal = modal
        }
        storeModal?.totPrice = self.totalPrice?.rounded().toString
        storeModal?.DeliveryCharge = self.totalDeliveryCost?.rounded().toString
        storeModal?.Tax = self.totalTax?.rounded().toString
        
        if let selectedCoupon = selectedCoupon {
            
            storeModal?.PromoCode = selectedCoupon.couponCode
        }
        else {
            
            storeModal?.PromoCode = ""
        }
        
//        storeModal?.PromoCode = self.totalPromoCodeValue?.rounded().toString
        storeModal?.WalletAmount = (/btnWalletSelect?.isSelected && self.walletAmtUsed != 0) ? self.walletAmtUsed.rounded().toString : nil
        storeModal?.Notes = txtNotes?.text?.trimmed()
        pickUpDropModal?.totPrice = self.totalPrice?.rounded().toString
        pickUpDropModal?.price = /self.totalPrice?.rounded(toPlaces: 2).toString
        pickUpDropModal?.Notes = txtNotes?.text?.trimmed()
        
        if /forPickUpAndDrop {
            pickUpDropModal?.promoCode = ""
        }
        
        self.paymentId = ""
        self.paymentErroCodeDesc = ""
        storeModal?.PaymentMode = "Online Payment"
        pickUpDropModal?.paymentMode = "Online Payment"
        self.placeOrder()
        
    }
    
    
    @IBAction func paymentViaCash(_ sender: UIButton)
    {
        
        cashFreeSelected = false
        upiPayment = false
        
        var storeModal : StoreOrdersModal?
        
        if let modal = self.storeOrderModal {
            storeModal = modal
        }
        storeModal?.totPrice = self.totalPrice?.rounded().toString
        storeModal?.DeliveryCharge = self.totalDeliveryCost?.rounded().toString
        storeModal?.Tax = self.totalTax?.rounded().toString
        
        if let selectedCoupon = selectedCoupon {
            
            storeModal?.PromoCode = selectedCoupon.couponCode
        }
        else {
            
            storeModal?.PromoCode = ""
        }
        
//        storeModal?.PromoCode = self.totalPromoCodeValue?.rounded().toString
        storeModal?.WalletAmount = (/btnWalletSelect?.isSelected && self.walletAmtUsed != 0) ? self.walletAmtUsed.rounded().toString : nil
        storeModal?.Notes = txtNotes?.text?.trimmed()
        pickUpDropModal?.totPrice = self.totalPrice?.rounded().toString
        pickUpDropModal?.price = /self.totalPrice?.rounded(toPlaces: 2).toString
        pickUpDropModal?.Notes = txtNotes?.text?.trimmed()
        
        if /forPickUpAndDrop {
            pickUpDropModal?.promoCode = ""
        }
        
        self.paymentId = ""
        self.paymentErroCodeDesc = ""
        storeModal?.PaymentMode = "CASH"
        pickUpDropModal?.paymentMode = "CASH"
        self.placeOrder()
    }
    
    @IBAction func upiPayment(_ sender: UIButton) {
        
        cashFreeSelected = false
        upiPayment = true
        let tag = sender.tag
        
        var storeModal : StoreOrdersModal?
        
        if let modal = self.storeOrderModal {
            storeModal = modal
        }
        storeModal?.totPrice = self.totalPrice?.rounded().toString
        storeModal?.DeliveryCharge = self.totalDeliveryCost?.rounded().toString
        storeModal?.Tax = self.totalTax?.rounded().toString
        
        if let selectedCoupon = selectedCoupon {
            
            storeModal?.PromoCode = selectedCoupon.couponCode
        }
        else {
            
            storeModal?.PromoCode = ""
        }
        
        storeModal?.WalletAmount = (/btnWalletSelect?.isSelected && self.walletAmtUsed != 0) ? self.walletAmtUsed.rounded().toString : nil
        storeModal?.Notes = txtNotes?.text?.trimmed()
        pickUpDropModal?.totPrice = self.totalPrice?.rounded().toString
        pickUpDropModal?.price = /self.totalPrice?.rounded(toPlaces: 2).toString
        pickUpDropModal?.Notes = txtNotes?.text?.trimmed()
        
        if /forPickUpAndDrop {
            pickUpDropModal?.promoCode = ""
        }
        
        self.paymentId = ""
        self.paymentErroCodeDesc = ""
        
        switch tag {
            
        case 3:
            storeModal?.PaymentMode = "Online Payment"
            pickUpDropModal?.paymentMode = "Online Payment"
            selectedUPI = .PHONEPE
            upiPayment = true
            placeOrder()
            break
            
        case 4:
            storeModal?.PaymentMode = "Online Payment"
            pickUpDropModal?.paymentMode = "Online Payment"
            selectedUPI = .GPAY
            upiPayment = true
            placeOrder()
            break
            
        case 5:
            storeModal?.PaymentMode = "Online Payment"
            pickUpDropModal?.paymentMode = "Online Payment"
            selectedUPI = .PAYTM
            upiPayment = true
            placeOrder()
            break
            
        default:
            upiPayment = false
            return
        }
    }
    
    @IBAction func btnWalletAct(_ sender : UIButton){
        self.view.endEditing(true)
        if !isWalletMoneyAllowed()  {
            ez.runThisInMainThread {
                AlertsClass.shared.showAlertController(withTitle: R.string.localize.attention(), message: kminimumCartValueWalletError.replace(target: "@", withString: "\(MIN_PRICE_FOR_WALLET_USED)"), buttonTitles: [R.string.localize.ok()]) { (tag) in
                    return
                }
            }
            return
        }
        btnWalletSelect?.isSelected = !(/btnWalletSelect?.isSelected)
        priceCalculation()
        lblWalletDeductAmt?.isHidden = !(/btnWalletSelect?.isSelected)
        
        if /btnWalletSelect?.isSelected {
            
            lblWalletDeductAmt?.isHidden = false
            walletViewHeight.constant = 70
        }
        else {
            
            lblWalletDeductAmt?.isHidden = false
            walletViewHeight.constant = 50
        }
        
        lblWalletDeductAmt?.text = R.string.localize.walletDeductAmt(self.walletAmtUsed.toString)
    
    }
    
    func isWalletMoneyAllowed() -> Bool {
        return MIN_PRICE_FOR_WALLET_USED <= /self.totalCost
    }
    
    func placeOrder() {
        
        Utility.shared.startLoader()
        if /forPickUpAndDrop {
            if let model = pickUpDropModal {
                self.hitAPI(pickUpModal: model, module: .PickUpAndDrop , paymentId: self.paymentId , paymentErroCodeDesc: self.paymentErroCodeDesc , paymentGateway: kCashFreePaymentGateway , isLoader: false)
            }
        }
        else {
            
            APIManager.shared.request(with: HomeEndpoint.saveStoreOrders(details: storeOrderModal?.toJSON()) , isLoader: self.paymentErroCodeDesc == "") { [weak self](response) in
                      self?.handle(response : response)
            }
        }
    }
    
    
    func handle(response : Response){
        switch response {
        case .success(let obj):
            if let response = obj as? StoreOrdersModal {
                if response.Status == "1" {
                    
                    if self.paymentErroCodeDesc == "" {
                        //Only when the payment done via cashfree
                        if cashFreeSelected {
                            if let orderId = response.result {
                                self.orderId = orderId
                                self.getCashFreeToken(orderId: orderId)
                            }
                        }
                        // only when pay via phonepe/gpay/paytm selected
                        else if upiPayment {
                            
                            if let orderId = response.result {
                                self.orderId = orderId
                                self.getCashFreeToken(orderId: orderId)
                            }
                        }
                        // if not done via cashfree / upi make it as COD
                        else {
                            Messages.shared.show(alert: .success, message: R.string.localize.orderPlacedSuccess(), type: .success)

                            openOrderSummaryVc(orderId : response.result)
                        }
                        
                    }
                   
                }
            }
            
            if let response = obj as? String {
                walletAmt = response.toDouble()
                if walletAmt != nil {
                    lblWallet?.text = R.string.localize.priceInRs(/walletAmt?.toString)
                    walletDeduction(walletAmt: walletAmt)
                }
            }
            
            if let response = obj as? CouponCodeModal {
                
                if response.value == nil {
                    Messages.shared.show(alert: .oops, message: /response.message, type: .warning)
                    txtPromoCode?.text = nil
                    totalPromoCodeValue = 0.0
                    lblCodeSuccessMsg?.isHidden = true
                }
                else {
                    if txtPromoCode?.text?.trimmed().uppercased() == response.CouponCode?.trimmed().uppercased() {
                        guard let value = response.value?.trimmed() else {
                            return
                        }
                        totalPromoCodeValue = value.toInt()?.toDouble
                        lblCodeSuccessMsg?.isHidden = response.CouponCode?.trimmed().uppercased() != "SURPISE"
                    }
                    
                }
                priceCalculation()
            }
            
            break
        case .failure(_):
            break
        }
    }
    
    func openOrderSummaryVc(orderId : String? , cashFreeModal : CashfreeModal? = nil) {
        
        let OrderId = getUpdateOrderId(orderId: orderId)
        
        if cashFreeSelected || upiPayment {
            if let modal = cashFreeModal {
                orderPaymentInfoForCashFree(cashFreeModal: modal)
            }
        }
        
        if /self.forPickUpAndDrop {
            
            ez.runThisInMainThread {
                
                self.navigateToRootVc()
            }
            
            return
        }
        
        
        guard let orderSummaryVc = R.storyboard.home.orderSummaryViewController() else {
            return
        }
       
        orderSummaryVc.orderModal = OrdersModal.init(orderId_: OrderId , orderType_ : "Store")
        orderSummaryVc.storeModal = self.storeModal
        ez.runThisInMainThread {
            
            self.pushVC(orderSummaryVc)
            Utility.shared.stopLoader()
        }
    }
    
    func orderPaymentInfoForCashFree(cashFreeModal : CashfreeModal , orderType : String? = "Store") {
        orderPaymentInfo(orderId:/self.orderId , paymentId: cashFreeModal.referenceId ?? "", orderType: orderType, paymentStatus: cashFreeModal.txStatus, errorCode: cashFreeModal.txMsg, paymentGateWay: kCashFreePaymentGateway , paymentMode: cashFreeModal.paymentMode)
    }
    
    
    func navigateToRootVc() {
        guard let viewControllers = self.navigationController?.viewControllers else {
            return
        }
        _ = viewControllers.map({ viewController in
            if viewController is TabBarController {
                (viewController as? TabBarController)?.selectedIndex = 0
                self.navigationController?.popToViewController(viewController, animated: false)
            }
        })
    }
    
    @IBAction func btnApplyPromoCodeAct(_ sender : UIButton){
        self.view.endEditing(true)
        if txtPromoCode?.text?.trimmed().count == 0 {
            Messages.shared.show(alert: .oops, message: "Please enter promo code", type: .warning)
            return
        }
        
        if let totalCost = totalCost {
            if totalCost < 200 {
                Messages.shared.show(alert: .oops, message: "Minimum cart amount should be Rs.200", type: .warning)
                return
            }
        }
        applyCoupon(promocode :  txtPromoCode?.text?.trimmed().uppercased())
        
    }
    
    
    func applyCoupon(promocode : String?){
        if let promoCode = promocode {
            APIManager.shared.request(with: HomeEndpoint.applyCoupon(promoCode: promoCode, UserID: UserID , storeID: /self.storeModal?.id)) {[weak self] (response) in
                self?.handle(response: response)
            }
        }
    }
    
}

//MARK::- Price Calculation
extension PaymentViewController {
    
    func priceCalculation() {
        guard let totalCost = totalCost else {
            return
        }
        
        viewPrice?.isHidden = /forPickUpAndDrop
        
        //tax calculation
        if tax != nil {
            totalTax = (((/tax * /totalCost.toDouble) * 1.0) / 100.0).rounded(toPlaces: 2)
            lblTax?.text = R.string.localize.priceInRs(/totalTax?.toString)
        }
        
        //distance cost calculation
        if pricePerKm != nil {
            
            //14.681448    77.55596183
            if let sourcePoint = self.sourcePoint {
                
                if destinationPoint == nil {
                    if let lat = self.storeModal?.Lattitude?.toDouble() , let longg = self.storeModal?.Longitude?.toDouble() {
                        self.destinationPoint = MKMapPoint(CLLocationCoordinate2D(latitude: lat, longitude: longg))
                    }
                }
                
                if let destinationPoint = destinationPoint {
                    
                    var distance = sourcePoint.distance(to: destinationPoint) / 1000
                        print("calculate distance :\(distance)")
                        
                        //add calculate distance + 2.0 suggested by Pradeep sir on 12thOct
                        if /forPickUpAndDrop {
                            distance = distance + 2
                        }
                        let distanceStr = NSString(format: "%.3f", distance) as String
                        print(distanceStr)
                        let calculatedDelieveryCost = (distance * /pricePerKm).rounded(toPlaces: 2)
                        if /forPickUpAndDrop {
                            if calculatedDelieveryCost <= /self.deliveryChargesFromAPI {
                                totalDeliveryCost = self.deliveryChargesFromAPI
                            }
                            else {
                                totalDeliveryCost = calculatedDelieveryCost
                            }
                            totalTax = (((/self.tax * /totalDeliveryCost) * 1.0) / 100.0).rounded(toPlaces: 2)
                            lblTax?.text = R.string.localize.priceInRs(/totalTax?.toString)
                        }
                        else {
                             if calculatedDelieveryCost <= /self.deliveryChargesFromAPI {
                                totalDeliveryCost = deliveryChargesFromAPI
                            }
                            else {
                                totalDeliveryCost = calculatedDelieveryCost
                            }
                            totalTax = (((/self.tax * /totalCost.toDouble) * 1.0) / 100.0).rounded(toPlaces: 2)
                            lblTax?.text = R.string.localize.priceInRs(/totalTax?.toString)
                        }
                }
                else {
                    
                    let distance: Double =  2.0
                    
                    let calculatedDelieveryCost = (distance * /pricePerKm).rounded(toPlaces: 2)
                    
                    if calculatedDelieveryCost <= /self.deliveryChargesFromAPI {
                        totalDeliveryCost = deliveryChargesFromAPI
                    }
                    else {
                        totalDeliveryCost = calculatedDelieveryCost
                    }
                    totalTax = (((/self.tax * /totalDeliveryCost) * 1.0) / 100.0).rounded(toPlaces: 2)
                    lblTax?.text = R.string.localize.priceInRs(/totalTax?.toString)
                }
            }
            else {
                
                let distance: Double =  2.0
                
                let calculatedDelieveryCost = (distance * /pricePerKm).rounded(toPlaces: 2)
                
                if calculatedDelieveryCost <= /self.deliveryChargesFromAPI {
                    totalDeliveryCost = self.deliveryChargesFromAPI
                }
                else {
                    totalDeliveryCost = calculatedDelieveryCost
                }
                totalTax = (((/self.tax * /totalDeliveryCost) * 1.0) / 100.0).rounded(toPlaces: 2)
                lblTax?.text = R.string.localize.priceInRs(/totalTax?.toString)
            }
            
            if /forPickUpAndDrop {
                
                lblDeliveryChargesLabel?.text = "Price"
            }
            
            lblDeliveryCharges?.text = R.string.localize.priceInRs(/totalDeliveryCost?.toString)
//            lblDeliveryChargesLabel?.text = /forPickUpAndDrop ? "Price" : "Delivery Charges"
            priceView?.isHidden = /forPickUpAndDrop
            
            if !(/forPickUpAndDrop) {
                
                if /totalDeliveryCost > 150.0 {
                    ez.runThisInMainThread {
                        AlertsClass.shared.showAlertController(withTitle: R.string.localize.attention(), message: "Please check your delivery location and proceed for placing order", buttonTitles: [R.string.localize.ok()]) { (tag) in
                            return
                        }
                    }
                }
            }
            else {
                
                if /totalDeliveryCost > 200.0 {
                    ez.runThisInMainThread {
                        AlertsClass.shared.showAlertController(withTitle: R.string.localize.attention(), message: "Please check your pickup,drop location and proceed for placing order", buttonTitles: [R.string.localize.ok()]) { (tag) in
                            return
                        }
                    }
                }
            }
        }
        
        if walletAmt != nil {
            lblWallet?.text = R.string.localize.priceInRs(/walletAmt?.toString)
        }
        
        lblPrice?.text = R.string.localize.priceInRs(totalCost.toDouble.rounded(toPlaces: 2).toString)
        lblWallet?.text = R.string.localize.priceInRs(/walletAmt?.rounded(toPlaces: 2).toString)
        
        if totalTax != nil && totalDeliveryCost != nil  {
            let walletAmtConsider = /btnWalletSelect?.isSelected ? /walletAmtUsed : 0.0
            totalPrice = /totalTax + totalCost.toDouble.rounded(toPlaces: 2) + /totalDeliveryCost - walletAmtConsider.rounded(toPlaces: 2) - /totalPromoCodeValue?.rounded(toPlaces: 2)
            lblPromoCode?.text = "-\(R.string.localize.priceInRs(/totalPromoCodeValue?.rounded(toPlaces: 2).toString))"
            lblTotal?.text = R.string.localize.priceInRs(/totalPrice?.rounded(toPlaces: 2).toString)
            lblRoundTotal?.text = R.string.localize.priceInRs(/totalPrice?.rounded().toString)
            navigationHeaderTitle.text = "Bill total: ₹\(/totalPrice?.rounded().toString)"
        }
    }
    
}
extension PaymentViewController {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPromoCode {
            self.view.endEditing(true)
        }
    }
}


//MARK::- Wallet deduction 15%


extension PaymentViewController {
    
    func walletDeduction(walletAmt : Double?){
        guard let walletAmt = walletAmt , let ttlCost = self.totalCost else {
            self.walletAmtUsed = 0.0
            return
        }
        
        if walletAmt == 0.0 {
            self.walletAmtUsed = 0.0
        }
        else {
            let calculatedAmt = (ttlCost.toDouble * 0.15)
            if calculatedAmt <= 50.0 {
                if walletAmt > calculatedAmt && (walletAmt - calculatedAmt) >= 50 {
                    self.walletAmtUsed = 50
                }
                else {
                    self.walletAmtUsed = walletAmt
                }
            }
            else {
                if walletAmt > calculatedAmt {
                    self.walletAmtUsed = calculatedAmt
                }
                else {
                    self.walletAmtUsed = walletAmt
                }
                
            }
        }
        self.byDefaultWalletEnabled()
    }
}

//MARK::- Cashfree integration
extension PaymentViewController : ResultDelegate {
    
    func getInputParams(orderId : String , token : String , currencySymbol : String , amount : String) -> Dictionary<String,Any> {
        
        if let userDetails = UDKeys.UserDTL.fetch() as? UserDetails {
            
            if let selectedUPI = selectedUPI {
                
                return [ "appId": kAppID,
                         "orderId": orderId,
                         "tokenData" : token,
                         "orderAmount": amount,
                         "customerName": /userDetails.name,
                         "orderNote": "",
                         "orderCurrency": currencySymbol,
                         "customerPhone": /userDetails.mobno,
                         "customerEmail": /userDetails.email,
                         "notifyUrl": "",
                         "appName": selectedUPI
                ]
            }
            else {
                
                return [ "appId": kAppID,
                         "orderId": orderId,
                         "tokenData" : token,
                         "orderAmount": amount,
                         "customerName": /userDetails.name,
                         "orderNote": "",
                         "orderCurrency": currencySymbol,
                         "customerPhone": /userDetails.mobno,
                         "customerEmail": /userDetails.email,
                         "notifyUrl": ""
                ]
            }
            
        }
        return [:]
    }
    
    func onPaymentCompletion(msg: String) {
        let jsonData = msg.data(using: .utf8)
        
        if cashFreeSelected {
            
            let cashFreeModal = CashfreeModal.init(json: JSON(jsonData!))
            self.onPaymentStatus(cashFreeModal)
        }
        else {
            
            let open = msg.replacingOccurrences(of: "[", with: "{")
            let close = open.replacingOccurrences(of: "]", with: "\"}")

            let first = close.replacingOccurrences(of: ": ", with: ": \"")
            let second = first.replacingOccurrences(of: ",", with: "\",")
            print(second)

            if let data = second.data(using: String.Encoding.utf8) {
                do {
                   let a = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: String]
                    
                    if let a = a {
                        
                        let cashFreeModal = CashfreeModal(orderId: a["orderId"], referenceId: a["referenceId"], orderAmount: a["orderAmount"], txStatus: a["txStatus"], txTime: a["txTime"], txMsg: a["txMsg"], paymentMode: a["paymentMode"], signature: a["signature"])
                        
                        self.onPaymentStatus(cashFreeModal)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func onPaymentStatus(_ cashFreeModal : CashfreeModal) {
        let status = CashFreePaymentStatus(rawValue: /cashFreeModal.txStatus) ?? .failure
        
        switch status {
        case .success:
            ez.runThisInMainThread {
                
                Messages.shared.show(alert: .success, message: R.string.localize.orderPlacedSuccess() , type: .success)
            }
            if let orderId = self.orderId {
                self.openOrderSummaryVc(orderId: orderId, cashFreeModal: cashFreeModal)
//                self.orderPaymentInfo(orderId: orderId, orderType: "Store")
            }
            //add code to navigate to payment success once it is done..
        default:
            self.orderPaymentInfoForCashFree(cashFreeModal: cashFreeModal) // This will inform user about the failure of the payment with reason
            DispatchQueue.main.async {

                AlertsClass.shared.showAlertController(withTitle: "Failure", message: cashFreeModal.txMsg ?? R.string.localize.somethingWentWrong(), buttonTitles: [R.string.localize.ok()]) { (_) in
                    return
                }
            }
        }
    }
}


extension PaymentViewController {
    
    
    func getNewOffers() {
        APIManager.shared.request(with: HomeEndpoint.getAllCouponsByStore(storeId : /self.storeModal?.id)) { [weak self](response) in
            self?.handleCoupons(response : response)
        }
    }
    
    func handleCoupons(response : Response){
        
        switch response {
        case .success(let obj):
            if let modal = obj as? [GetOffersModal]{
                self.getOffersModal = modal
                navigateToCouponVC()
            }
            
        case .failure(_):
            break
        }
        Utility.shared.stopLoader()
    }
    
    func navigateToCouponVC() {
        
        guard let vc = R.storyboard.main.couponViewController() else {
            return
        }
        vc.coupons = self.getOffersModal
        vc.delegate = self
        vc.cartAmount = self.totalCost
        self.present(vc, animated: false) {
            
            Utility.shared.stopLoader()
        }
    }
}

extension PaymentViewController : SelectCouponDelegate {
    
    func selectCoupon(coupon: GetOffersModal) {
       
        selectedCoupon = coupon
        print(coupon)
        viewAll.setTitle("Remove", for: .normal)
        txtPromoCode?.text = coupon.couponCode
        selectedCouponLabel.textColor = .black
        selectedCouponLabel.text = coupon.couponCode
    
        totalPromoCodeValue = maxDiscountCalculator(deductionType: coupon.deductionType, value: coupon.value, maxDiscount: coupon.maxDiscountAmount)
        lblPromoCode?.text = "-\(R.string.localize.priceInRs(/totalPromoCodeValue?.rounded(toPlaces: 2).toString))"
        
        priceCalculation()
    }
}


extension PaymentViewController {
    
    
    func maxDiscountCalculator(deductionType: String?, value: String?, maxDiscount: String?) -> Double {
        
        
        if let deductionType = deductionType, let value = value {
            
            if deductionType == "DirectValue" {
                
                return Double(value)!
            }
            else {
                
                let val = totalCost! * Int(value)!
                let discount = Double(val) / 100.0
                if let maxDiscount = maxDiscount {
            
                    if discount > Double(maxDiscount)! {
                        
                        return Double(maxDiscount)!
                    }
                    else {
                        
                        return discount
                    }
                }
                return 100.0
                
            }
        }
        else {
            
            return 0.0
        }
        
    }
    
    func getUpdateOrderId(orderId : String?) -> String {
        return /orderId
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension PaymentViewController {
    func getCashFreeToken(orderId : String , currency : String? = "INR") {
        self.orderId = orderId
        let orderAmount = "\(/totalPrice?.rounded())"
//        let orderAmount = "1"
        let cashFreeTokenModel = CashFreeTokenModal(orderID_: orderId, orderAmount_: orderAmount, orderCurrency_: currency)
        APIManager.shared.request(with: HomeEndpoint.getCashFreeToken(details: cashFreeTokenModel.toJSON() , env : kEnv), isLoader: true) { response in
            switch response {
            case .success(let obj):
           
            if let response = obj as? StoreOrdersModal {
                if response.Status == "200" {
                    if self.cashFreeSelected {
                    
                        CFPaymentService().doWebCheckoutPayment(params: self.getInputParams(orderId: orderId, token: /response.result, currencySymbol: /currency, amount: orderAmount), env: kEnv, callback: self)
                    }
                    else if self.upiPayment {
                    
                        CFPaymentService().doUPIPayment(params: self.getInputParams(orderId: orderId, token: /response.result, currencySymbol: /currency, amount: orderAmount), env: kEnv, callback: self)
                    }
                }
            }
            case .failure(_):
                break
            }
            
            if !self.paymentFromPickupDrop {
                
                Utility.shared.stopLoader()
            }
        }
    }
}

extension UIView {

    func doGlowAnimation() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: -3.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 3.0, y: 0.5)
    
        let gradientAnimation = CABasicAnimation(keyPath: "startPoint")
        gradientAnimation.fromValue = gradientLayer.startPoint
        gradientAnimation.toValue = gradientLayer.endPoint
        gradientAnimation.duration = 0.5
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity

        gradientLayer.add(gradientAnimation, forKey: "startPoint")
        
        layer.mask = gradientLayer
    }
}
