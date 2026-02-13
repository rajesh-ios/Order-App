//
//  PickUpandDropDetailsViewController.swift
//  Dodoo
//
//  Created by Apple on 26/02/21.
//  Copyright © 2021 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit
//import EZSwiftExtensions

class PickUpandDropDetailsViewController: BaseViewController {

    @IBOutlet weak var lblHeading : UILabel?
    @IBOutlet weak var txtDoorNo : UITextField?
    @IBOutlet weak var txtLandMark : UITextField?
    @IBOutlet weak var pickDropView: UIView!
    
    var addressType : AddressType? = .pick
    var pricePerKm : Double?
    var taxForPickUp : Double?
    var pickUpModal : PickUpDropModal?
    var deliveryChargesFromAPI : Double?
    var pickUpCordinate : CLLocationCoordinate2D?
    var dropCordinate : CLLocationCoordinate2D?
    var autoCompleteDelegate: GoogleAutoCompleteDelegate?
    let controller = GMSAutocompleteViewController()
    var fromVc : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PickUpandDropDetailsViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(PickUpandDropDetailsViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func updateUI() {
        lblHeading?.text = addressType?.getHeaderPlacholder()
        txtDoorNo?.placeholder = addressType?.getDoorNoPlacholder()
        txtLandMark?.placeholder = addressType?.getLandmarkPlaceholder()
    }
    
    @IBAction func btnSaveAddressAct(_ sender : UIButton) {
        guard let vc = R.storyboard.main.myAddressesViewController() else {
            return
        }
        vc.fromPickUpAndDrop = true
        vc.selectAddressDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func updateModal() {
        
        let lat = UDKeys.UsedLat.fetch() != nil ? UDKeys.UsedLat.fetch() as! Double : UDKeys.CurrentLat.fetch() as! Double
        let long = UDKeys.UsedLong.fetch() != nil ? UDKeys.UsedLong.fetch() as! Double : UDKeys.CurrentLong.fetch() as! Double
        
        if addressType == .pick {
            self.pickUpModal?.pickUpAddress = self.txtDoorNo?.text
            self.pickUpModal?.landMarkPickUpAddress = self.txtLandMark?.text
            if let pickUpCordinate = pickUpCordinate {
                
                self.pickUpModal?.PickLattitude = pickUpCordinate.latitude.toString
                self.pickUpModal?.PickLongitude = pickUpCordinate.longitude.toString
            }
            else {
                
                self.pickUpModal?.PickLattitude = "\(lat)"
                self.pickUpModal?.PickLongitude = "\(long)"
            }
            
        }
        else {
            self.pickUpModal?.dropAddress = self.txtDoorNo?.text
            self.pickUpModal?.landMarkDropAddress = self.txtLandMark?.text
            if let dropCordinate = dropCordinate {
                
                self.pickUpModal?.DropLattitude = dropCordinate.latitude.toString
                self.pickUpModal?.DropLongitude = dropCordinate.longitude.toString
            }
            else {
                
                self.pickUpModal?.DropLattitude = "\(lat)"
                self.pickUpModal?.DropLongitude = "\(long)"
            }
        }
    }
    
    @IBAction func btnProceed(_ sender : UIButton) {
        updateModal()
        
        if "".validatePickUpAndDropPoints(pickUpDoorNumber: txtDoorNo?.text?.trimmed(), pickUpAreaName: txtLandMark?.text?.trimmed(), addressType: addressType ?? .pick) {
        if addressType == .pick {
            guard let vc = R.storyboard.home.pickUpandDropDetailsViewController() else {
                return
            }
            vc.addressType = .drop
            vc.pickUpModal = pickUpModal
            vc.pickUpCordinate = pickUpCordinate
            vc.fromVc = fromVc
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        else {
            getConfgurationDetails()
        }
        }
    }
}


extension PickUpandDropDetailsViewController  {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtLandMark {
//            showGooglePicker()
        }
    }
    
    //MARK: - Move to Google Search
    func showGooglePicker() {
        
        autoCompleteDelegate = GoogleAutoCompleteDelegate(placePickerVC: self.controller)
        controller.tableCellBackgroundColor = .white
        controller.delegate = self.autoCompleteDelegate
        autoCompleteDelegate?.applyFilter(with: .address)
        self.present(controller, animated: true, completion: nil)
        
        /// display autocomplete
        autoCompleteDelegate?.show(selectedLocation: { (place) in
//            debugPrint("Selected Location:" , \place.addressComponents))
            print("Place name: \(/place.name)")
            print("Place ID: \(/place.placeID)")
            print("Place lat : \(place.coordinate.latitude) , long : \(place.coordinate.longitude)")
            self.txtLandMark?.text = /place.name
            if self.addressType == .pick{
                self.pickUpCordinate = place.coordinate
            }
            else {
                self.dropCordinate = place.coordinate
            }
            
        }, cancelled: {})
    }
}

extension PickUpandDropDetailsViewController {
    
    func navigateToPaymentVc() {
       
        guard let paymentVC = R.storyboard.home.paymentViewController() else{
            return
        }
        paymentVC.pickUpDropModal = pickUpModal
        if let pickUpPoint = pickUpCordinate {
            paymentVC.sourcePoint = MKMapPoint(pickUpPoint)
        }
        if let dropPoint = dropCordinate {
            paymentVC.destinationPoint = MKMapPoint(dropPoint)
        }
    
        paymentVC.tax = self.taxForPickUp
        paymentVC.totalCost = 0
        paymentVC.forPickUpAndDrop = true
        paymentVC.deliveryChargesFromAPI = self.deliveryChargesFromAPI
        //suggest by pradeep to hardcode it to 7 due to unavaialbility of backend developer
        paymentVC.pricePerKm = self.pricePerKm
        
        fromVc?.dismiss(animated: false, completion: {
            
            self.fromVc?.pushVC(paymentVC)
        })
//        self.parent?.pushVC(paymentVC)
    }
}

extension PickUpandDropDetailsViewController {
    func getConfgurationDetails() {
        if let cityCode = UDKeys.CityCode.fetch() as? String  {
            ConfigurationHandler.getConfiguration(cityCode: cityCode) { _,taxForPickUp,pricePerKm, _, deliveryChargesForPickUpAndDrop, error in
                self.deliveryChargesFromAPI = deliveryChargesForPickUpAndDrop
                self.pricePerKm = pricePerKm
                self.taxForPickUp = taxForPickUp
                self.navigateToPaymentVc()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first
        if touch?.view != pickDropView {
            self.dismiss(animated: false)
        }
    }
}


extension PickUpandDropDetailsViewController : SelectAddressDelegate {
    func selectAddress(_ address : MyAddressesModal) {
        txtDoorNo?.text = address.DoorNo
        txtLandMark?.text = address.address
        if addressType == .pick {
            self.pickUpCordinate = CLLocationCoordinate2D(latitude: /address.Latitude?.toDouble(), longitude: /address.Longitude?.toDouble())
        }
        else {
            self.dropCordinate = CLLocationCoordinate2D(latitude: /address.Latitude?.toDouble(), longitude: /address.Longitude?.toDouble())
        }
    }
}

extension PickUpandDropDetailsViewController {

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
