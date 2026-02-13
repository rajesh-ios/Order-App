//
//  OtpVerifyViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 8/24/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

let kInstructions = "Please type the verification code sent to "
let kEnterOtp = "Please enter OTP"
let kValidOtp = "Please enter valid OTP"

class OtpVerifyViewController: BaseViewController {
    
    @IBOutlet weak var lblInstructions : UILabel?
    @IBOutlet weak var btnResendOTP : UIButton?
    @IBOutlet weak var otpView : PinCodeTextField?
    @IBOutlet weak var lblTimer : UILabel?
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var mobileNumber : String?
    var isFirstTime : Bool = true
    var resendOtpTimer: Timer!
    var timerCount = 60
    var generatedOtp : String?
    var enteredOtp : String?
    var isResendOTPEnabled : Bool? {
        didSet {
            updateUI()
        }
    }
    var userModal: ParentResponseModal?
    
    var registerModal: RegisterModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        onViewDidLoad()
        isResendOTPEnabled = false
        otpView?.delegate = self
    }
    
    func onViewDidLoad() {
        if let mobileNumber = mobileNumber {
            lblInstructions?.text = "\(mobileNumber)"
            sendCode()
        }
    }
    
    func updateUI() {
        btnResendOTP?.isEnabled = /isResendOTPEnabled
        btnResendOTP?.setTitleColor(/isResendOTPEnabled ? UIColor.ColorApp : UIColor.gray, for: .normal)
        btnResendOTP?.alpha = /isResendOTPEnabled ? 1.0 : 0.5
        lblTimer?.isHidden = /isResendOTPEnabled
        if !(/isResendOTPEnabled) {
            startTimer()
        }
    }
    
    
    @IBAction func btnResendOtpAct(_ sender : UIButton){
        self.sendCode()
    }
    
    
    @IBAction func btnSubmitAct(_ sender : UIButton){
        
        guard let otpEnteredByUser = enteredOtp , !otpEnteredByUser.isEmpty else {
            Messages.shared.show(alert: .oops, message: kEnterOtp, type: .warning)
            return
        }
        
        if otpEnteredByUser.compare(/self.generatedOtp).rawValue != 0 {
            Messages.shared.show(alert: .oops, message: kValidOtp, type: .warning)
        }
        else {
            
            Utility.shared.startLoader()
            APIManager.shared.request(withImage: LoginEndpoint.register(details:registerModal?.toJSONString()), image : nil) { [weak self] (response) in
                    self?.handleResponse(response: response, responseBack: { (success) in
                    Utility.shared.stopLoader()
                    self?.handle(response : success)
                    })
            }
        }
    }
    
    
    func sendCode() {
        guard let mobileNo = mobileNumber else {
            return
        }
        Utility.shared.startLoader()
        APIManager.shared.request(with: LoginEndpoint.validateMobileNo(mobileNo: mobileNo)) { response in
            self.handleResponse(response: response) { [weak self] success in
                Utility.shared.stopLoader()
                self?.handleOtpSuccess(modal : success)
            }
        }
    }
    
    func handleOtpSuccess(modal : AnyObject?) {
        if let modal = modal as? RegisterModal {
            if modal.Status == "1" {
                self.generatedOtp = modal.Result
                if isFirstTime {
                    isFirstTime = !isFirstTime
                }
                else {
                    Messages.shared.show(alert: .success, message: "OTP Sent Successfully", type: .success)
                }
            }
        }
    }
    
    func handle(response : AnyObject?){
            if let regModal = response as? ParentResponseModal ,  let modal = regModal.RegisterUserInfoResult , let status = modal.status , let message = modal.message {
                
                userModal = regModal
    
                if status == "1"  && message == "Success"{
                    
                    guard let tabBarVc = R.storyboard.main.tabBarController() else {return}
                    tabBarVc.selectedIndex = 0
                    
                    if let userModal = userModal, let regModal = userModal.RegisterUserInfoResult {
                        
                        UDKeys.UserDTL.save(regModal)
                        self.pushVC(tabBarVc)
                    }
                }
                else if status == "0"{
                    Messages.shared.show(alert: .oops, message: message, type: .warning)
                }
            }
        }
}

extension OtpVerifyViewController {
    
    
    func startTimer() {
        timerCount = 60
        self.resendOtpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Counting), userInfo: nil, repeats: true)
        self.resendOtpTimer.fire()
    }
    
    func stopTimer() {
        if resendOtpTimer != nil {
            resendOtpTimer!.invalidate()
            self.isResendOTPEnabled = true
        }
    }
    
    @objc func Counting() {
        if timerCount == 0 {
            self.stopTimer()
        } else {
            timerCount -= 1
            if timerCount >= 10 {
                lblTimer?.text = ("\("00:")\(timerCount)")
            } else {
                lblTimer?.text = ("\("00:")\("0")\(timerCount)")
            }
        }
    }
    
}


extension OtpVerifyViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        self.enteredOtp = value
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}




extension  OtpVerifyViewController{
    
    func addToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        self.otpView?.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
}
