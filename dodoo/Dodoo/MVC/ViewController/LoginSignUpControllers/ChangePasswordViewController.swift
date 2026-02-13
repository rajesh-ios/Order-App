//
//  ChangePasswordViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/24/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    
    @IBOutlet weak var lblMainHeading : UILabel?
//    @IBOutlet weak var lblFirstSubHeading : UILabel?
    @IBOutlet weak var confirmPasswordView : UIView?
    @IBOutlet weak var txtChangePassword : UITextField?
    @IBOutlet weak var txtConfirmPassword : UITextField?
    
    @IBOutlet weak var newPassword: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var module : Module?
    var isSecurePassword: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        onViewDidLoad()
        newPassword.setTitle("", for: .normal)
        confirmButton.setTitle("", for: .normal)
        
        txtChangePassword?.delegate = self
        txtConfirmPassword?.delegate = self
    }
    
    func onViewDidLoad() {
        
        if let module = module {
            lblMainHeading?.text = module.rawValue
            if module == .ForgotPassword {
                txtChangePassword?.isSecureTextEntry = false
                txtChangePassword?.placeholder = "Phone Number"
//                lblFirstSubHeading?.text = "Enter Email/Mobile No"
                newPassword.isHidden = true
                txtChangePassword?.isSecureTextEntry = false
            }
            confirmPasswordView?.isHidden = module == .ForgotPassword
        }
    }
    
    
    @IBAction func btnForgotPasswordAct(_ sender : UIButton){
        
        Utility.shared.startLoader()
        if module == .ForgotPassword {
            
            if txtChangePassword?.text?.trimmed().count == 0 {
                Messages.shared.show(alert: .oops, message: "Please enter Mobile Number", type: .warning)
                return
            }
            else {
                
                if validatePhone(value: (txtChangePassword?.text)!) {
                    
                    view.endEditing(true)
                    forgotPassword()
                }
                else {
                    
                    Messages.shared.show(alert: .oops, message: R.string.localize.validMobileNumberLength(), type: .warning)
                    return
                }
            }
            
        }
        else if module == .ChangePassword {
            if txtChangePassword?.text?.trimmed().count == 0 {
                Messages.shared.show(alert: .oops, message: "Please enter new password", type: .warning)
                return
            }
            else if txtConfirmPassword?.text?.trimmed().count == 0 {
                Messages.shared.show(alert: .oops, message: "Please re-type password", type: .warning)
                return
            }
            else {
                if txtChangePassword?.text?.trimmed() != txtConfirmPassword?.text?.trimmed() {
                    Messages.shared.show(alert: .oops, message: "Password does not match", type: .warning)
                    return
                }
            }
            changePassword()
        }
    }
    
    @IBAction func newPasswordClicked(_ sender: UIButton) {
        
        isSecurePassword = !isSecurePassword
        newPassword.setImage(UIImage(named: isSecurePassword ? "eye_close" : "eye"), for: .normal)
        txtChangePassword?.isSecureTextEntry = isSecurePassword
    }
    
    @IBAction func confirmPasswordClicked(_ sender: UIButton) {
        
        isSecurePassword = !isSecurePassword
        confirmButton?.setImage(UIImage(named: isSecurePassword ? "eye_close" : "eye"), for: .normal)
        txtConfirmPassword?.isSecureTextEntry = isSecurePassword
    }
    
    func forgotPassword(){
        APIManager.shared.request(with: LoginEndpoint.forgotPassword(email: txtChangePassword?.text?.trimmed())) { [weak self](response) in
            self?.handle(response : response)
        }
    }
    
    
    func changePassword() {
        APIManager.shared.request(with: LoginEndpoint.changePassword(newpassword: txtChangePassword?.text?.trimmed() , userID : /self.UserID)) { [weak self](response) in
            self?.handle(response : response)
        }
    }
    
    func handle(response : Response){
        
        switch response {
        case .success(let success):
            if let modal = success as? RegisterModal {
                
                if modal.Status == "1" {
                    if module == .ForgotPassword {
                        Messages.shared.show(alert: .success, message: /modal.Result, type: .success)
                        
                    }
                    else {
                          Messages.shared.show(alert: .success, message: "Password changed Successfully", type: .success)
                    }
                    self.popVC()
                }
                else {
                    Messages.shared.show(alert: .oops, message: "User doesn't exist", type: .warning)
                }
            }
            case .failure(_):
              Messages.shared.show(alert: .oops, message: R.string.localize.skip(), type: .warning)
        }
        Utility.shared.stopLoader()
    }
}

extension ChangePasswordViewController {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if module == .ForgotPassword {
            
            if textField == txtChangePassword {
                
                if txtChangePassword?.text?.trimmed().count == 0 {
                    
                    return true
                }
                else {
                    
                    if validatePhone(value: txtChangePassword?.text ?? "") == true {
                        
                        return true
                    }
                    else {
                        
                        Messages.shared.show(alert: .oops, message: R.string.localize.validMobileNumberLength(), type: .warning)
                        return false
                    }
                }
                
            }
            return true
        }
        return true
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if module == .ForgotPassword {
            
            if textField == txtChangePassword {
                
                let newLength = textField.text!.count + string.count - range.length

                return newLength <= 10
            }
            return true
            
        }
        return true
        
    }
    
}
