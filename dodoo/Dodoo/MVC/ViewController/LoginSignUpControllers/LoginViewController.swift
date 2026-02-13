//  Mobile No :- 9035083483
//  Password :- Test@1234
//  LoginViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/23/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//


import UIKit
import FBSDKCoreKit
//import EZSwiftExtensions
import GoogleSignIn
import SafariServices

typealias socialLoginDict = (String?,String?,String?,String?,String?)?


class LoginViewController: BaseViewController , GIDSignInUIDelegate {

    //MARK::- OUTLETS
    @IBOutlet weak var txtMobNo : UITextField?
    @IBOutlet weak var txtPassword : UITextField?
    @IBOutlet weak var btnLogin : UIButton?
    @IBOutlet weak var btnPasswordEye : UIButton?
    var socialLogin : Bool = false
    var signInFrom : String?
//    var socialDict : socialLoginDict?
    var socialEmailId : String?
    var isSecurePassword : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        txtMobNo?.delegate = self
        txtPassword?.delegate = self
//        txtMobNo?.text = "9035083483"
//        txtPassword?.text = "Test@1234"
        btnPasswordEye?.setTitle("", for: .normal)
    }
    
    func onViewDidLoad(){
        GIDSignIn.sharedInstance().uiDelegate = self

    }
    
    
    @IBAction func btnLoginAct(_ sender : UIButton){
        signInFrom = ""
        socialLogin = false
        authenticateUser()
    }
    
    
    
    
    @IBAction func btnSignUpAct(_ sender : UIButton){
        guard let vc = R.storyboard.main.signUpViewController() else {return}
        self.pushVC(vc)
    }
    
    @IBAction func btnForgotPasswordAct(_ sender : UIButton){
        guard let vc = R.storyboard.main.changePasswordViewController() else {return}
        vc.module = .ForgotPassword
        self.pushVC(vc)
    }
    
    @IBAction func btnSecurePasswordAct(_ sender : UIButton){
        isSecurePassword = !isSecurePassword
        btnPasswordEye?.setImage(UIImage(named: isSecurePassword ? "eye_close" : "eye"), for: .normal)
        txtPassword?.isSecureTextEntry = isSecurePassword
    }
    
    
    @IBAction func btnFbLogin(_ sender: UIButton){
        SocialNetworkClass.shared.facebookLogin {[weak self](fbId, name, email, img) in
            Utility.shared.stopLoader()
             self?.socialEmailId = email
             self?.socialLogin = true
             self?.signInFrom = "Facebook"
             self?.isUserAlreadyExist()
//                self?.authenticateUser()
        }
    }
    
    @IBAction func btnGoogleLogin(_ sender : UIButton){
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        
        SocialNetworkClass.shared.googleLogin {[weak self] (googleId,name, email, img) in
            Utility.shared.stopLoader()
            self?.socialEmailId = email
            self?.signInFrom = "Gmail"
            self?.socialLogin = true
            self?.isUserAlreadyExist()
//            self?.socialDict = (nil, googleId, email, img, name)
//            self?.authenticateUser()
        }
    }
    
    func isUserAlreadyExist() {
        
        APIManager.shared.request(with: LoginEndpoint.validateUser(email: self.socialEmailId), isLoader: false) { (response) in
            self.handleResponse(response: response, responseBack: { (success) in
                 self.handleValidateUserResponse(response: success)
            })
        }
    }
    
    func handleValidateUserResponse(response : Any?){
        if let model = response as? RegisterModal , let status = model.Status {
            switch status {
           
            //user does not exists
            case "1":
                guard let vc = R.storyboard.main.signUpViewController() else {return}
                vc.socialEmailId = self.socialEmailId
                vc.socialLogin = true
                self.pushVC(vc)
                
            //user exists with  mobileNo exits
            case "2":
                self.authenticateUser()
                
            //user exists and without mobile no
            case "3":
                break
                
            default:
                break
            }
        }
    }

}


//MARK::- API Authenticate and handle response
extension LoginViewController {
    func authenticateUser() {
        if !socialLogin{
            if txtMobNo?.text?.trimmed().count == 0 {
                Messages.shared.show(alert: .oops, message: "Please enter Mobile Number", type: .warning)
            return
        }
        else if txtPassword?.text?.trimmed().count == 0 {
            Messages.shared.show(alert: .oops, message: "Please enter password", type: .warning)
            return
        }
            
        }
        self.view.endEditing(true)
        
        if validatePhone(value: (txtMobNo?.text)!) {
            
            let authenticationModal = AuthenticationModal.init(userid_: socialLogin ? socialEmailId : txtMobNo?.text, reg_id_: UDKeys.FCMToken.fetch() as? String, Pasword_: txtPassword?.text, SingleSignon_: socialLogin, SignOnFrom_:signInFrom)
            Utility.shared.startLoader()
            APIManager.shared.request(with: LoginEndpoint.authentication(details: authenticationModal.toJSON())) {[weak self](response) in
                Utility.shared.stopLoader()
                self?.handle(response : response)
            }
        }
        
    }
    
    func handle(response : Response){
        
        switch  response {
        case .success(let object):
            if let modal = object as? UserDetails {
                if modal.status == "1" && modal.message == "Success" {
                    UDKeys.UserDTL.save(modal)
                    self.navigateToHome()
                }
                else if modal.status == "0"{
                    Messages.shared.show(alert: .oops, message: /modal.message, type: .warning)
                }
            }
        case .failure(let error):
             Messages.shared.show(alert: .oops, message: /error?.description, type: .warning)
            break
        }
    }
    
    func navigateToHome() {
        guard let tabBarVc = R.storyboard.main.tabBarController() else {return}
        tabBarVc.selectedIndex = 0
        self.pushVC(tabBarVc)
    }
}


extension LoginViewController {
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMobNo {
            txtPassword?.becomeFirstResponder()
            return false
        }
        else if textField == txtPassword {
            txtPassword?.resignFirstResponder()
            return true
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtMobNo {
            
            if txtMobNo?.text?.trimmed().count == 0 {
                
                return true
            }
            else {
                
                if validatePhone(value: txtMobNo?.text ?? "") == true {
                    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        if textField == txtMobNo {
                
            let newLength = textField.text!.count + string.count - range.length

            return newLength <= 10
        }
        return true
    }

}





