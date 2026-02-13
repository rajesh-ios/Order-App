//
//  PickUpDropViewController.swift
//  Dodoo
//
//  Created by Banka Rajesh on 11/12/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
import GooglePlaces
import GoogleMaps
import MapKit

class PickUpDropViewController: BaseViewController, UIScrollViewDelegate {
    
    
    //MARK::- OUTLETS
    
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemDescriptionTV: UITextView!
    @IBOutlet weak var senderReceiverNameTF: UITextField!
    @IBOutlet weak var senderReceiverNumberTF: UITextField!
    @IBOutlet weak var bottomTopView: UIView!
    @IBOutlet weak var pickupDropAddressView: UIView!
    @IBOutlet weak var texViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickupDropViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickupAddressTV: UITextView!
    @IBOutlet weak var dropOffAddressTV: UITextView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickupAddressHeightConst: NSLayoutConstraint!
    @IBOutlet weak var dropAddressHeightCont: NSLayoutConstraint!
    
    //MARK::- VARIBLES

    var pickUpCordinate : CLLocationCoordinate2D?
    var dropCordinate : CLLocationCoordinate2D?
    
    var placeholderLabel = UILabel()
        
    //MARK ::- LIFE CYLCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemNameTF.delegate = self
        senderReceiverNameTF.delegate = self
        senderReceiverNumberTF.delegate = self
        itemDescriptionTV.delegate = self
        
        pickupAddressTV.delegate = self
        dropOffAddressTV.delegate = self
        
        itemDescriptionTV.textColor = .lightGray
        pickupAddressTV.textColor = .lightGray
        dropOffAddressTV.textColor = .lightGray
        
        onViewDidLoad()
        bottomTopView.isHidden = true
        
        scrollView.delegate = self
        scrollView.bounces = scrollView.contentOffset.y > 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func onViewDidLoad() {

        guard let userDetails = UDKeys.UserDTL.fetch() as? UserDetails else {
            return
        }

        senderReceiverNameTF?.text = userDetails.name
        senderReceiverNumberTF?.text = userDetails.mobno
    }
    
    @IBAction func nxtButtonClicked(_ sender: UIButton) {
        
        if itemNameTF.text?.trimmed().count == 0 {
            
            Messages.shared.show(alert: .oops, message: " enter item name", type: .warning)
        }
        else if (itemDescriptionTV.text == "Leave some detail instructions") || (itemDescriptionTV.text.trimmed().count == 0) {
            
            Messages.shared.show(alert: .oops, message: " enter item description", type: .warning)
        }
        else if senderReceiverNameTF.text?.trimmed().count == 0 {
            
            Messages.shared.show(alert: .oops, message: " enter sender/receiver name", type: .warning)
        }
        else if senderReceiverNumberTF.text?.trimmed().count == 0 {
            
            Messages.shared.show(alert: .oops, message: " enter sender/receiver mobile number", type: .warning)
        }
        else {
            
            self.view.endEditing(true)
            bottomTopView.isHidden = false
        }
    }
    
    @IBAction func proceedButtonClicked(_ sender: UIButton) {
        
        if (pickupAddressTV.text?.trimmed().count == 0) || (pickupAddressTV.text == "Enter Complete Pickup Address") {
            
            Messages.shared.show(alert: .oops, message: "Enter detailed pickup address", type: .warning)
        }
        else if (dropOffAddressTV.text?.trimmed().count == 0) || (dropOffAddressTV.text == "Enter Complete Drop Address") {
            
            Messages.shared.show(alert: .oops, message: "Enter detailed drop address", type: .warning)
        }
        else {
            
            self.view.endEditing(true)
            
            let lat = UDKeys.UsedLat.fetch() != nil ? UDKeys.UsedLat.fetch() as! Double : UDKeys.CurrentLat.fetch() as! Double
            let long = UDKeys.UsedLong.fetch() != nil ? UDKeys.UsedLong.fetch() as! Double : UDKeys.CurrentLong.fetch() as! Double
            
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let result = formatter.string(from: date)
            let timeResult = Date().toString(format: "HH:mm a")

            let pickUpModal = PickUpDropModal.init(id_: "0", name_: senderReceiverNameTF.text ?? "", Title_: itemNameTF.text ?? "", Desc_: itemDescriptionTV.text ?? "", ContactNo_: senderReceiverNumberTF.text ?? "", Status_: "Open", UserID_: UserID, SaveAddress_: false, date_: result, time_: timeResult, price_: "", totPrice_: "")
            
            pickUpModal.PickLattitude = "\(lat)"
            pickUpModal.PickLongitude = "\(long)"
            pickUpModal.pickUpAddress = pickupAddressTV.text ?? ""
            
            pickUpModal.DropLattitude = "\(lat)"
            pickUpModal.DropLongitude = "\(long)"
            pickUpModal.dropAddress = dropOffAddressTV.text ?? ""
            
            pickUpModal.landMarkPickUpAddress = pickupAddressTV.text ?? ""
            pickUpModal.landMarkDropAddress = dropOffAddressTV.text ?? ""
            
            if let cityCode = UDKeys.CityCode.fetch() as? String {
                
                pickUpModal.CityCode = cityCode + "_"
            }
            
            guard let paymentVC = R.storyboard.home.paymentViewController() else{
                return
            }
            
            pickUpCordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            dropCordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            if let cityCode = UDKeys.CityCode.fetch() as? String  {
                ConfigurationHandler.getConfiguration(cityCode: cityCode) { _,taxForPickUp,pricePerKm, _, deliveryChargesForPickUpAndDrop, error in
                    
                    paymentVC.sourcePoint = MKMapPoint(self.pickUpCordinate!)
                    paymentVC.destinationPoint = MKMapPoint(self.dropCordinate!)
                
                    paymentVC.tax = taxForPickUp
                    paymentVC.totalCost = 0
                    paymentVC.forPickUpAndDrop = true
                    paymentVC.deliveryChargesFromAPI = deliveryChargesForPickUpAndDrop
                   
                    paymentVC.pricePerKm = pricePerKm
                    paymentVC.pickUpDropModal = pickUpModal
                        
                    self.pushVC(paymentVC)
                    
                    self.bottomTopView.isHidden = true
                }
            }
            else {
                
                self.bottomTopView.isHidden = true
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        
        self.popVC()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
        
              return
            }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height - 74 , right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        if !(bottomTopView.isHidden) {
            if bottomTopView.frame.origin.y == 0 {
                
                bottomViewBottomConstraint.constant = keyboardSize.height
            }
            
            
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if !(bottomTopView.isHidden) {
            
            bottomViewBottomConstraint.constant = 0.0
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension PickUpDropViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        if textView.frame.height < 48.0 {
            
            self.texViewHeightConstraints.constant = 48.0
        }
        if (textView.text.isEmpty) || (textView.text?.trimmed().count == 0) {
            
            switch textView {
                
            case itemDescriptionTV: do {
                
                textView.text = "Leave some detail instructions"
            }
            case pickupAddressTV: do {
                
                textView.text = "Enter Complete Pickup Address"
            }
            case dropOffAddressTV: do {
                
                textView.text = "Enter Complete Drop Address"
            }
            default:
                
                break
            }
            
            textView.textColor = UIColor.lightGray
        }
        
        switch textView {
            
        case itemDescriptionTV: do {
            
            self.itemDescriptionTV.text = textView.text
        }
        case pickupAddressTV: do {
            
            self.pickupAddressTV.text = textView.text
        }
        case dropOffAddressTV: do {
            
            self.dropOffAddressTV.text = textView.text
        }
        default:
            
            break
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.textColor = .darkGray
        
        switch textView {
            
        case itemDescriptionTV: do {
            
            var frame = self.itemDescriptionTV.frame
            frame.size.height = self.itemDescriptionTV.contentSize.height
            self.itemDescriptionTV.frame = frame
            if textView.frame.height < 48.0 {
                
                self.texViewHeightConstraints.constant = 48.0
            }
            else {
                
                self.texViewHeightConstraints.constant = frame.size.height
            }
        }
        case pickupAddressTV: do {
            
            var frame = self.pickupAddressTV.frame
            frame.size.height = self.pickupAddressTV.contentSize.height
            self.pickupAddressTV.frame = frame
            if textView.frame.height < 48.0 {
                
                self.pickupAddressHeightConst.constant = 48.0
            }
            else {
                
                self.pickupAddressHeightConst.constant = frame.size.height
            }
        }
        case dropOffAddressTV: do {
            
            var frame = self.dropOffAddressTV.frame
            frame.size.height = self.dropOffAddressTV.contentSize.height
            self.dropOffAddressTV.frame = frame
            if textView.frame.height < 48.0 {
                
                self.dropAddressHeightCont.constant = 48.0
            }
            else {
                
                self.dropAddressHeightCont.constant = frame.size.height
            }
        }
        default: break
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let placetextColor = UIColor.lightGray
        
        if textView.textColor == placetextColor {
            textView.text = ""
            textView.textColor = .black
        }
        else {
            
            textView.textColor = .black
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
        if textView.text.count >= 255 && text != "" {
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
        
        switch touch?.view {
            
        case self.pickupDropAddressView: do {
            
            self.bottomTopView.isHidden = false
        }
            
        case self.bottomTopView: do {
        
            self.bottomTopView.isHidden = true
        }
            
        default:
            self.bottomTopView.isHidden = true
        }
    }
}
