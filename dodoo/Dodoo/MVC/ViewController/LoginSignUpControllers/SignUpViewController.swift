
//
//  SignUpViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/24/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet weak var txtEmail : UITextField?
    @IBOutlet weak var txtPassword : UITextField?
    @IBOutlet weak var txtConfirmPassword  : UITextField?
    @IBOutlet weak var txtMobileNo : UITextField?
    @IBOutlet weak var txtReferralCode : UITextField?
    @IBOutlet weak var txtName : UITextField?
    @IBOutlet weak var btnPasswordEye : UIButton?
    @IBOutlet weak var btnConfirmPasswordEye : UIButton?
    @IBOutlet weak var accept_T_C: UIButton!
    @IBOutlet weak var blackToRedText: UILabel!
    
    
    var socialLogin : Bool? = false
    var socialEmailId : String?
    var isSecurePassword : Bool = true
    var isConfirmassword : Bool = true
    var accepted: Bool = false

    var registerModal: RegisterModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        btnPasswordEye?.setTitle("", for: .normal)
        btnConfirmPasswordEye?.setTitle("", for: .normal)
        
        txtMobileNo?.delegate = self
        txtEmail?.delegate = self
        txtPassword?.delegate = self
        txtConfirmPassword?.delegate = self
        txtName?.delegate = self
        txtReferralCode?.delegate = self
    }
    
    
    func onViewDidLoad() {
        if /socialLogin {
           txtEmail?.isUserInteractionEnabled = false
           txtEmail?.text = socialEmailId
        }
    }
    
    
    @IBAction func btnSignUpAct(_ sender : UIButton){
        if "".validSignUp(name: txtName?.text?.trimmed(), email: txtEmail?.text?.trimmed(), password: txtPassword?.text, confirm: txtConfirmPassword?.text, mobNo: txtMobileNo?.text){
            register()
        }
    }
    
    @IBAction func btnPasswordEyeAct(_ sender : UIButton){
        isSecurePassword = !isSecurePassword
        btnPasswordEye?.setImage(UIImage(named: isSecurePassword ? "eye_close" : "eye"), for: .normal)
        txtPassword?.isSecureTextEntry = isSecurePassword
    }
    
    @IBAction func btnConfirmPasswordEyeAct(_ sender : UIButton){
        isConfirmassword = !isConfirmassword
        btnConfirmPasswordEye?.setImage(UIImage(named: isConfirmassword ? "eye_close" : "eye"), for: .normal)
        txtConfirmPassword?.isSecureTextEntry = isConfirmassword
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        self.navigationController == nil ? dismissVC(completion: nil) : popVC()
    }
    @IBAction func terms_conditionClicked(_ sender: UIButton) {
        
        guard let vc = R.storyboard.main.commonTnCPrivacyVC() else {
            return
        }
        vc.termsNconditionDelegate = self
        self.presentVC(vc)
    }
    
    @IBAction func terms_condition_RadioButton_Clicked(_ sender: UIButton) {
        
        if accepted {
            
            accepted = false
            accept_T_C.setImage(UIImage(named: "radio_button_unfilled"), for: .normal)
        }
        else {
            
            accepted = true
            blackToRedText.textColor = .black
            accept_T_C.setImage(UIImage(named: "radio_btn_filled"), for: .normal)
        }
        
    }
    
    func register() {
        
        if accepted {
            
            registerModal = RegisterModal.init(id_: "0", name_: txtName?.text?.trimmed(), email_: txtEmail?.text?.trimmed(), mobno_: txtMobileNo?.text?.trimmed(), password_: txtPassword?.text?.trimmed(), address_: "", imageName_: "", docName_: "" , ReferredByCode_ : txtReferralCode?.text?.trimmed())
            
            navigateToOtpVerfiyVC(modal: registerModal!)
        }
        else {
            
            blackToRedText.textColor = .red
            Messages.shared.show(alert: .warning, message: "Accept terms & conditions", type: .warning)
        }
    }
        
    func navigateToOtpVerfiyVC(modal: RegisterModal) {
        guard let vc = R.storyboard.main.otpVerifyViewController() else {
            return
        }
        vc.registerModal = modal
        vc.mobileNumber = /txtMobileNo?.text?.trimmed()
        self.pushVC(vc)
    }
}


extension SignUpViewController {
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtEmail?.becomeFirstResponder()
            return true
        }
        else if textField == txtEmail {
            txtMobileNo?.becomeFirstResponder()
           return true
            
        }
        else if textField == txtMobileNo {
            txtPassword?.becomeFirstResponder()
           return true
        }
        else if textField == txtPassword {
            txtConfirmPassword?.becomeFirstResponder()
           return true
            
        }
        else if textField == txtConfirmPassword {
            txtReferralCode?.becomeFirstResponder()
            return true
            
        }
        else if textField == txtReferralCode {
            txtReferralCode?.resignFirstResponder()
           return true 
        }
        else {
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtMobileNo {
            if validatePhone(value: txtMobileNo?.text ?? "") == true
                {
                return true
            }
            else {
                
                Messages.shared.show(alert: .oops, message: R.string.localize.validMobileNumberLength(), type: .warning)
                
                return true
            }
        }
        else if textField == txtEmail {
            
            if isValidEmail(email: txtEmail?.text ?? "") == true
                {
                return true
            }
            else {
                
                Messages.shared.show(alert: .oops, message: "Please Enter a Valid Email ID", type: .warning)
                
                return true
            }
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        if textField == txtMobileNo {
                
            let newLength = textField.text!.count + string.count - range.length

            return newLength <= 10
        }
        return true
            
    }
}

extension BaseViewController {
    
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^[6-9][0-9]{9}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension SignUpViewController: CommonTnCDelegate {
    
    func acceptedTnC() {
        
        self.accepted = true
        blackToRedText.textColor = .black
        accept_T_C.setImage(UIImage(named: "radio_btn_filled"), for: .normal)
    }
}
