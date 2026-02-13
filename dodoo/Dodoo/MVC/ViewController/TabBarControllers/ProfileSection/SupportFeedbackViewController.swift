
//
//  SupportFeedbackViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/28/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class SupportFeedbackViewController: BaseViewController {
    
    @IBOutlet weak var txtSubject : UITextField?
    @IBOutlet weak var uplaodImage : UITextField?
    @IBOutlet weak var txtType : UITextField?
    @IBOutlet weak var txtDesc : UITextView?
    @IBOutlet weak var txtAttachment : UITextField?
    @IBOutlet weak var lblHeading : UILabel?
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var module : Module?
    var typeOptions : [String] = [R.string.localize.enquiry() , R.string.localize.customerSupport()]
    var pickerView : UIPickerView!
    var uploadImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        txtType?.text = R.string.localize.enquiry()
        lblHeading?.text = module?.id
    }
    
    @IBAction func btnAttachmentAct(_ sender : UIButton){
        CameraGalleryPickerBlock.shared.pickerImage(pickedListner: {[weak self](image , filename) in
            self?.uploadImage = image
            self?.txtAttachment?.text = filename
        }) {}
    }
    
    @IBAction func btnSubmitAct(_ sender : UIButton){
        self.view.endEditing(true)
        
        if txtSubject?.text?.trimmed().count == 0 {
           Messages.shared.show(alert: .oops, message: "Please enter subject", type: .warning)
        }
        else if txtDesc?.text?.trimmed().count == 0 {
             Messages.shared.show(alert: .oops, message: "Please enter description", type: .warning)
        }
        else {
            sendSupportFeedback()
        }
    }
    
    func sendSupportFeedback() {
        var imageName : String? = nil
        if self.uploadImage != nil {
            imageName = module == .Feedback ? "feedback_\(Date().toString()).jpeg" : "support_\(Date().toString()).jpeg"
        }
        let modal = SupportFeedbackModal.init(id_: "0", Type_: txtType?.text, Desc_: txtDesc?.text, UserID_: self.UserID, ImageName_: "imageName" , Subject_ : txtSubject?.text)
        if let module = module {
            Utility.shared.startLoader()
            APIManager.shared.request(withImage: LoginEndpoint.supportFeedback(module: module, details: modal.toJSONString()), image: [self.uploadImage ?? UIImage()]) { [weak self](response) in
                self?.handleResponse(response: response, responseBack: { (success) in
                    self?.handle(response : success)
                })
            }
        }
    }
    
    func handle(response : AnyObject?){
        if module == .Support {
            if let modal = response as? ParentResponseModal , let regModal = modal.RegisterSupportResult , let status = regModal.Status , let Result = regModal.Result {
                
                handleResponseAction(status : status , Result : Result)
            }
        }
        else {
            if let modal = response as? ParentResponseModal , let regModal = modal.RegisterFeedbackResult , let status = regModal.Status , let Result = regModal.Result {
                handleResponseAction(status : status , Result : Result)

            }
        }
        Utility.shared.stopLoader()
    }
    
    func handleResponseAction(status : String , Result : String) {
        if status == "1" {
            Messages.shared.show(alert: .success, message: module == .Support ? "Your response has been recorded . Our representative will contact you shortly" : "Thanks for your feedback", type: .success)
            self.popVC()
            
        }
        else if status == "0"{
            Messages.shared.show(alert: .oops, message: Result, type: .warning)
        }
    }
}

extension SupportFeedbackViewController {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtType{
            self.pickUp(textField)
        }
    }
}


extension SupportFeedbackViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return typeOptions.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtType?.text =  typeOptions[row]
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.ColorApp
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        doneButton.tintColor = UIColor.flatGreen
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        cancelButton.tintColor = UIColor.flatGreen
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func doneClick() {
        self.txtType?.resignFirstResponder()
    }
    @objc func cancelClick() {
        self.txtType?.resignFirstResponder()
    }
    
}

