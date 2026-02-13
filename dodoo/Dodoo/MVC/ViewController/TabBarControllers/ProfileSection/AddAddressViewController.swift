//
//  AddAddressViewController.swift
//  Dodoo
//
//  Created by Shubham Dhingra on 29/09/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class AddAddressViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var txtName : UITextField?
    @IBOutlet weak var txtDoorNo : UITextField?
    @IBOutlet weak var lblAddress : UILabel?
    @IBOutlet weak var txtMobileNo : UITextField?
    @IBOutlet weak var btnAdd : UIButton?
    @IBOutlet weak var fetcherTableView : UITableView?
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    var actions : Actions? = .Add
    var model : MyAddressesModal?
    var currentLabel : UILabel?
    var currentCordinate : CLLocationCoordinate2D?
    var autoCompleteDelegate: GoogleAutoCompleteDelegate?
    let controller = GMSAutocompleteViewController()
    var tableData = [String]()
    var fetcher: GMSAutocompleteFetcher?
    var cityName : String?
//    var fetcherTableView : UITableView?
    
    var distanceFromDeliveryToAddedAddress: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        onViewDidLoad()
    }
    
    func onViewDidLoad(){
        if actions == .Add {
            guard let userDetails = UDKeys.UserDTL.fetch() as? UserDetails else {
                return
            }
            txtMobileNo?.text = userDetails.mobno
        }
        
        if actions == .Edit {
            
            if let model = self.model {
                
                txtName?.text = model.title
                txtDoorNo?.text = model.DoorNo
                lblAddress?.text = model.address
                txtMobileNo?.text = model.Mobile
                currentCordinate = CLLocationCoordinate2D(latitude: /model.Latitude?.toDouble(), longitude: /model.Longitude?.toDouble())
            }
        }
        
        btnAdd?.setTitle(actions == .Add ? "Add" : "Save", for: .normal)
//        setUpAutoCompleteFetcherOnTextField(lblAddress ?? UITextField())
    }
    
    
    func distanceCalculator(sourceLat: Double, sourceLong: Double, destinationCooredinate: CLLocationCoordinate2D) -> Double {
        
        let sourcePoint = MKMapPoint(CLLocationCoordinate2D(latitude: sourceLat , longitude: sourceLong ))
        
        let destinationPoint = MKMapPoint(destinationCooredinate)
        
        return sourcePoint.distance(to: destinationPoint) / 1000
    }
    
    @IBAction func btnAddAct(_ sender : UIButton){
        if "".validateAddAddress(txtName?.text?.trimmed(), doorNo: txtDoorNo?.text?.trimmed(), contactNo: txtMobileNo?.text?.trimmed(), fullAddress: lblAddress?.text?.trimmed()) {
            
            if (lblAddress?.text != "nearest landmark") {
                
                
                if let usedLat = UDKeys.UsedLat.fetch(),let usedLong = UDKeys.UsedLong.fetch() {
                    
                    if distanceCalculator(sourceLat: usedLat as! Double, sourceLong: usedLong as! Double, destinationCooredinate: currentCordinate!) > 50 {
                        
                        Messages.shared.show(alert: .warning, message: "Store to delivery address is greater than 50kms, please provide valid address", type: .warning)
                    }
                    else {
                        
                        addOrUpdateAddress()
                    }
                }
                else {
                    
                    if let currLat = UDKeys.CurrentLat.fetch(),let currLong = UDKeys.CurrentLong.fetch() {
                        
                        if distanceCalculator(sourceLat: currLat as! Double, sourceLong: currLong as! Double, destinationCooredinate: currentCordinate!) > 50 {
                            
                            Messages.shared.show(alert: .warning, message: "Store to delivery address is greater than 50kms, please provide valid address", type: .warning)
                        }
                        else {
                            
                            addOrUpdateAddress()
                        }
                    }
                }
            }
            else {
                
                Messages.shared.show(alert: .warning, message: "Please select nearest landmark", type: .warning)
            }
        }
    }
    
    @IBAction func getCurrentLocationAct(_ sender : UIButton){
        
        guard let vc = R.storyboard.home.addLocationViewController() else {
            return
        }
        
        if let coordinates = currentCordinate {
            
            vc.currentCordinate = coordinates
            vc.location = lblAddress?.text ?? ""
            vc.currencLocation = false
        }
        else {
            
            if let lat = UDKeys.CurrentLat.fetch(), let long = UDKeys.CurrentLong.fetch() {
                
                let coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                
                vc.currentCordinate = coordinate
                vc.currencLocation = true
            }
        }
        
        vc.delegate = self
        self.presentVC(vc)
    }
}


extension AddAddressViewController {
    
    func addOrUpdateAddress(){
        
        let modal = MyAddressesModal(addressId: actions == .Add ? "0" : /model?.Addressid, UserId: UserID, Title: txtName?.text?.trimmed() , Address: lblAddress?.text?.trimmed(), isCurrentAddress: actions == .Add ? false : /model?.isCurrentAddress, Mobile: txtMobileNo?.text?.trimmed(), Longitude: /self.currentCordinate?.longitude.toString, Latitude: /self.currentCordinate?.latitude.toString, DoorNo: txtDoorNo?.text?.trimmed(), type: "" , city : actions == .Add ? cityName : /model?.City)
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.addOrUpdateAddress(details: modal.toJSON()) , isLoader: true) {[weak self](response) in
            self?.handleResponse(response: response, responseBack: { (success) in
                self?.handleAddressResponse(response: success)
            })
        }
    }
    
    func handleAddressResponse(response : AnyObject?){
        if let regModal = response as? RegisterModal , let status = regModal.Status , let Result = regModal.Result {
            
            if status == "1" && (Result == "Insert Success"){
                Messages.shared.show(alert: .success, message: "Address added successfully", type: .success)
            }
            
            if status == "1" && Result == "Update Success" {
                Messages.shared.show(alert: .success, message: "Address updated successfully", type: .success)
            }
            NotificationCenter.default.post(name: .UPDATE_ADDRESS_RECORD, object: nil, userInfo : nil)
            
            if let _ = self.navigationController {
                
                self.popVC()
            }
            else {
                
                self.dismiss(animated: false)
            }
            
        }
        Utility.shared.stopLoader()
    }
}

extension AddAddressViewController: AddLocationControlDelegate {
    
    func passLocationData(location: String, address1: String, address2: String, city: String, zipCode: String, coordinates: CLLocationCoordinate2D) {
        
        self.currentLabel?.text = location
        self.lblAddress?.text = location
        self.cityName = city
        self.currentCordinate = coordinates
    }
}
