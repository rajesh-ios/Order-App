//
//  PickUpAndDropViewController.swift
//  Dodoo
//
//  Created by Shubham on 15/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
import GooglePlaces
import GoogleMaps
import MapKit

class PickUpAndDropViewController: BaseViewController {
    
    
    //MARK::- OUTLETS
    @IBOutlet weak var dateTimeView : UIView?
    @IBOutlet weak var pickUpAddressView : UIView?
    @IBOutlet weak var pickUpLandmarkView : UIView?
    @IBOutlet weak var dropLandmarkView : UIView?
    @IBOutlet weak var dropAddressView : UIView?
    @IBOutlet weak var deliveryCycleView : UIView?
    @IBOutlet weak var btnSubmit : UIButton?
    @IBOutlet weak var lblPickUpAddress : UILabel?
    @IBOutlet weak var lblPickUpLandmark : UILabel?
    @IBOutlet weak var btnSaveAddress : UIButton?
    
    @IBOutlet weak var txtItemName : UITextField?
    @IBOutlet weak var txtItemDesc : UITextView!
    @IBOutlet weak var txtEnterPickUpAddress : UITextField?
    @IBOutlet weak var txtEnterPickUplandmark : UITextField?
    @IBOutlet weak var txtEnterDropAddress : UITextField?
    @IBOutlet weak var txtEnterDroplandmark : UITextField?
    @IBOutlet weak var txtName : UITextField?
    @IBOutlet weak var txtContactNo : UITextField?
    
    @IBOutlet weak var lblDate : UILabel?
    @IBOutlet weak var lblTime : UILabel?
    @IBOutlet weak var lblHeading : UILabel?
    @IBOutlet var btnDeliveryCycleOutltes : [UIButton]!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    
    //MARK::- VARIBLES
    var module : Module?
    var currentTextField : UITextField?
    var selectDeliveryCycle : String?
    var autoCompleteDelegate: GoogleAutoCompleteDelegate?
    let controller = GMSAutocompleteViewController()
    var pickUpCordinate : CLLocationCoordinate2D?
    var dropCordinate : CLLocationCoordinate2D?
    var placeholderLabel = UILabel()
    
    
    
    //MARK ::- LIFE CYLCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        onViewDidLoad()
        setUpTextViewPlaceholder()
    }
    
    
    func setUpTextViewPlaceholder() {
        txtItemDesc.delegate = self
        placeholderLabel.text = "Description"
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtItemDesc.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtItemDesc.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 3, y: (txtItemDesc.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !(/txtItemDesc.text?.isEmpty)
    }
    
    func onViewDidLoad() {
        if let mod = module {
            lblHeading?.text = mod.id
//            dateTimeView?.isHidden = mod == .Subscription
//            dropLandmarkView?.isHidden = mod == .Subscription
//            dropAddressView?.isHidden = mod == .Subscription
            pickUpAddressView?.isHidden = mod == .PickUpAndDrop
            pickUpLandmarkView?.isHidden = mod == .PickUpAndDrop
            deliveryCycleView?.isHidden = !(mod == .Subscription)
            lblPickUpAddress?.text = mod == .Subscription ? R.string.localize.nearestAddress() : R.string.localize.pickUpAddress()
            lblPickUpLandmark?.text = mod == .Subscription ? R.string.localize.nearestLandmark() : R.string.localize.pickUpLandmark()
            btnSubmit?.setTitle(mod == .Subscription ? R.string.localize.proceed() : R.string.localize.proceedToPay() , for:  .normal)
        }
        
        guard let userDetails = UDKeys.UserDTL.fetch() as? UserDetails else {
            return
        }
        
        txtName?.text = userDetails.name
        txtContactNo?.text = userDetails.mobno
        //        txtEnterPickUpAddress?.text = userDetails.address
        //        txt?.text = userDetails.landMark
        //
        //        if let lat = userDetails.latitude , let longi = userDetails.longitude {
        //            sourcePoint = MKMapPoint(CLLocationCoordinate2D(latitude: lat, longitude: longi))
        //        }
    }
    
    
    //MARK::- BUTTON ACTIONS
    @IBAction func btnSubmitAct(_ sender : UIButton){
        self.view.endEditing(true)
        if "".validatePickUpAndDrop(title: txtItemName?.text?.trimmed(), desc: txtItemDesc?.text?.trimmed(), pickUpDoorNumber: txtEnterPickUpAddress?.text?.trimmed(), pickUpAreaName: txtEnterPickUplandmark?.text?.trimmed(), name: txtName?.text?.trimmed(), contactNo: txtContactNo?.text?.trimmed(), module: self.module, selectDate: lblDate?.text, selectTime: lblTime?.text, selectDeliveryCycle: selectDeliveryCycle) {
            prepareModal()
        }
    }
    
    
    func prepareModal() {
        
        if module == .Subscription {
            let pickUpModal  = PickUpDropModal.init(id_: "0", name_: txtName?.text, Title_: txtItemName?.text, Desc_: txtItemDesc?.text, ContactNo_: txtContactNo?.text, address_: txtEnterPickUpAddress?.text, Status_: "Open", UserID_: UserID, DelvryCycle_: selectDeliveryCycle, SaveAddress_: btnSaveAddress?.isSelected, LandMarkAddress_: txtEnterPickUplandmark?.text)
            hitAPI(pickUpModal : pickUpModal , module: module, paymentId: "",paymentErroCodeDesc: "", isLoader: true)
        }
        else {
            
            //Navigate To Payment Vc in case of pickUp And Drop
            let pickUpModal = PickUpDropModal.init(id_: "0", name_: txtName?.text, Title_: txtItemName?.text, Desc_: txtItemDesc?.text, ContactNo_: txtContactNo?.text, Status_: "Open", UserID_: UserID, SaveAddress_: btnSaveAddress?.isSelected, date_: lblDate?.text, time_: lblTime?.text, price_: "", totPrice_: "")
            
            guard let vc = R.storyboard.home.pickUpandDropDetailsViewController() else {
                return
            }
            vc.pickUpModal = pickUpModal
            vc.fromVc = self
            
//            self.navigationController?.presentVC(vc)
            self.presentVC(vc)
        }
    }
    
    
    @IBAction func dateTimeAct(_ sender : UIButton){
        chooseDate(btn : (sender.tag == 0 ? lblDate : lblTime) ?? lblDate!)
    }
    
    @IBAction func btnSaveThisAddressAct(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func btnDeliveryAct(_ sender : UIButton){
        selectDeliveryCycle(tag : sender.tag)
    }
    
    
    func selectDeliveryCycle(tag : Int){
        for (index , _) in btnDeliveryCycleOutltes.enumerated() {
            btnDeliveryCycleOutltes[index].setBackgroundColor(index == tag ? UIColor.black :  UIColor.white  , forState: .normal)
            btnDeliveryCycleOutltes[index].setTitleColor(index == tag ? UIColor.ColorApp : UIColor.black , for: .normal)
        }
        selectDeliveryCycle = self.btnDeliveryCycleOutltes?[tag].currentTitle
    }
}

extension PickUpAndDropViewController {
    
    func chooseDate(btn : UILabel) {
        self.view.endEditing(true)
        let lastText  = btn.tag != 0 ? lblTime?.text : lblDate?.text
        DatePickerDialog().show(btn.tag != 0 ? R.string.localize.chooseTime() : R.string.localize.chooseDate(), doneButtonTitle: R.string.localize.done(), cancelButtonTitle: R.string.localize.cancel(), minimumDate: btn.tag != 0 ? nil : Date() , maximumDate: nil, datePickerMode: btn.tag != 0 ? .time : .date , lastText: lastText) { (date) in
            if let dt = date {
                if btn.tag != 0 {
                    self.lblTime?.text = dt.dateConvert(time: dt, format: DateFormat.date2.id)
                }
                else {
                    self.lblDate?.text = dt.dateConvert(time: dt, format: DateFormat.date1.id)
                }
                
            }
        }
    }
}

extension PickUpAndDropViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtItemDesc {
            textView.resignFirstResponder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}
