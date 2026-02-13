
//
//  AccountDetailsViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/22/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class AccountDetailsViewController: BaseViewController {

    @IBOutlet weak var btnEdit : UIButton?
    @IBOutlet weak var txtName : UITextField?
    @IBOutlet weak var txtEmailAddress : UITextField?
    @IBOutlet weak var txtMobileNo : UITextField?
    @IBOutlet weak var txtAddress : UITextField?
    @IBOutlet weak var txtUploadDoc : UITextField?
    @IBOutlet weak var btnUploadProfilePic : UIButton?
    @IBOutlet weak var btnUploadDoc : UIButton?
    @IBOutlet weak var imgProfilePic : UIImageView?
    @IBOutlet weak var btnSubmit : UIButton?
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    var imageArr = [UIImage]()
    var imageName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        imageArr.append(UIImage())
        imageArr.append(UIImage())
//        setAccessToEdit(allowed: false)
        txtMobileNo?.isUserInteractionEnabled = false
        txtName?.isUserInteractionEnabled = false
        txtEmailAddress?.isUserInteractionEnabled = false
         setUpUserDetails()
        
        imgProfilePic?.layer.borderWidth = 1.0
        imgProfilePic?.layer.borderColor = UIColor.lightGray.cgColor
        imgProfilePic?.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(AccountDetailsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(AccountDetailsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
        
    @IBAction func btnUploadDoc(_ sender : UIButton){
        CameraGalleryPickerBlock.shared.pickerImage(pickedListner: {[weak self](image , filename) in
            
                switch sender.tag {
                case 0 :
                    self?.imgProfilePic?.image = image
                    self?.imageArr[0] = image
                    self?.imageName = "image_ios_profile.jpeg"
                    
                case 1:
                    self?.imageArr[1] = image
//                    self?.txtUploadDoc?.text = "image_ios_doc.jpeg"
                default:
                    break
                }
                
            }) {}
    }
    
    @IBAction func btnEditAct(_ sender : UIButton){
        setAccessToEdit(allowed: true)
        txtName?.becomeFirstResponder()
    }
    
    @IBAction func btnSubmitAct(_ sender : UIButton){
        
        if let userDTL = UDKeys.UserDTL.fetch() as? UserDetails , let id = userDTL.id {
            let modal = RegisterModal.init(id_: id, name_: txtName?.text?.trimmed(), email_: txtEmailAddress?.text?.trimmed(), mobno_: txtMobileNo?.text?.trimmed(), password_: "", address_: txtAddress?.text?.trimmed(), imageName_: imageName == nil ? "" : imageName , docName_: imageName == nil ? "" : imageName, ReferredByCode_: self.txtUploadDoc?.text ?? "")
            
            Utility.shared.startLoader()
            APIManager.shared.request(withImage: LoginEndpoint.register(details:modal.toJSONString()), image : imageArr) { [weak self] (response) in
                self?.handleResponse(response: response, responseBack: { (success) in
                    self?.handle(response : success)
                })
            }
        }
    }
    
    func setUpUserDetails() {
        if let modal = UDKeys.UserDTL.fetch() as? UserDetails {
            txtName?.text = modal.name
            txtEmailAddress?.text = modal.email
            txtMobileNo?.text = modal.mobno
            txtAddress?.text = modal.address
            txtUploadDoc?.text = modal.referalCode
            if modal.referalCode == "" {
                
                txtUploadDoc?.isUserInteractionEnabled = true
            }
            else {
                
                txtUploadDoc?.isUserInteractionEnabled = false
            }
            if modal.updateProfilPic != nil {
                imgProfilePic?.image =  modal.updateProfilPic
            }
            imgProfilePic?.loadURL(urlString: modal.imagePath, placeholder: nil, placeholderImage: R.image.profile())
//            btnSubmit?.isHidden = true
        }
    }
    
    func handle(response : AnyObject?){
        if let modal = response as? ParentResponseModal , let regModal = modal.RegisterUserInfoResult , let status = regModal.status , let Result = regModal.message {
            
            if status == "1" && Result == "Success" {
                Messages.shared.show(alert: .success, message: "Account Details Update Succesfully", type: .success)
                self.updateModal(regModal : regModal)
                self.popVC()
                
            }
            else if status == "0"{
                Messages.shared.show(alert: .oops, message: Result, type: .warning)
            }
        }
        Utility.shared.stopLoader()
    }
    
    func updateModal(regModal : UserDetails) {
        
        if let userDTL = UDKeys.UserDTL.fetch() as? UserDetails {
            userDTL.address = txtAddress?.text?.trimmed()
            userDTL.mobno = txtMobileNo?.text?.trimmed()
            userDTL.name = txtName?.text?.trimmed()
            userDTL.imagePath = regModal.imagePath
            userDTL.docPath = regModal.docPath
            userDTL.docName = regModal.docPath
            userDTL.doc = regModal.doc
            UDKeys.UserDTL.save(userDTL)
        }
    }
    
    
    func setAccessToEdit(allowed : Bool?) {
        if let allowAccess = allowed {
        txtName?.isUserInteractionEnabled = allowAccess
        txtEmailAddress?.isUserInteractionEnabled = allowAccess
        txtMobileNo?.isUserInteractionEnabled = allowAccess
        txtAddress?.isUserInteractionEnabled = allowAccess
        btnUploadProfilePic?.isUserInteractionEnabled = allowAccess
        btnUploadDoc?.isUserInteractionEnabled = allowAccess
        btnSubmit?.isHidden = !allowAccess
        btnEdit?.isHidden = allowAccess
        }
        txtUploadDoc?.isUserInteractionEnabled = false
    }
}


extension AccountDetailsViewController {
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtName == textField {
            txtEmailAddress?.becomeFirstResponder()
             return false
        }
        else if txtEmailAddress == textField {
            txtMobileNo?.becomeFirstResponder()
             return false
        }
        else if txtMobileNo == textField {
             txtAddress?.becomeFirstResponder()
             return false
        }
        else if txtAddress == textField {
            txtAddress?.resignFirstResponder()
            return false
        }
        else if txtUploadDoc == textField {
            txtUploadDoc?.resignFirstResponder()
            return false
        }
        else {
            
            return true
        }
    }
}

extension AccountDetailsViewController {

@objc func keyboardWillShow(notification: NSNotification) {
        
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
       // if keyboard size is not available for some reason, dont do anything
       return
    }
  
  // move the root view up by the distance of keyboard height
  self.view.frame.origin.y = 0 - keyboardSize.height
}

@objc func keyboardWillHide(notification: NSNotification) {
  // move back the root view origin to zero
  self.view.frame.origin.y = 0
}
}
