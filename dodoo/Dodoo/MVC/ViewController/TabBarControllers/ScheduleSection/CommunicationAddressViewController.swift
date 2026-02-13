//
//  CommunicationAddressViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/5/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
import GooglePlaces
import MapKit
import GoogleMaps


class CommunicationAddressViewController: BaseViewController {

    @IBOutlet weak var txtName : UITextField?
    @IBOutlet weak var txtAddress : UITextField?
    @IBOutlet weak var lblLandMark : UILabel?
    @IBOutlet weak var txtContactNo : UITextField?
    @IBOutlet weak var btnSubmit : UIButton?

    var autoCompleteDelegate: GoogleAutoCompleteDelegate?
    let controller = GMSAutocompleteViewController()
    var currentTextField : UITextField?
    var totalCost : Int?
    var selectItems : [Items]?
    var storeModal : StoresModal?
    var storeOrderModal : StoreOrdersModal?
    var updateId : String? = "0"
    var tax : Double?
    var pricePerKm : Double?
    var sourcePoint : MKMapPoint?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    func onViewDidLoad() {
        
        guard let userDetails = UDKeys.UserDTL.fetch() as? UserDetails else {
            return
        }
        
        txtName?.text = userDetails.name
        txtContactNo?.text = userDetails.mobno
        txtAddress?.text = userDetails.address
        lblLandMark?.text = userDetails.landMark
        
        if let lat = userDetails.latitude , let longi = userDetails.longitude {
             sourcePoint = MKMapPoint(CLLocationCoordinate2D(latitude: lat, longitude: longi))
        }
    }
    
    @IBAction func btnSubmitAct(_ sender : UIButton){
        self.view.endEditing(true)
        if "".saveStoreOrders(name: txtName?.text?.trimmed(), address: txtAddress?.text?.trimmed(), Landmark: lblLandMark?.text?.trimmed(), contactNo: txtContactNo?.text?.trimmed()) {
             saveStoreOrders()
        }
    }
    
    @IBAction func btnOpenPickerAct(_ sender : UIButton){
         showGooglePicker()
    }
}

//MARK::- SAVE STORE ORDERS API
extension CommunicationAddressViewController {
    func saveStoreOrders() {

        var cartItemsArr = [[String: Any]]()
        if let selectItems = selectItems {
            for (_ , item) in selectItems.enumerated() {

                let cartItems = CartItems.init(Title_: item.ItemName, Desc_: item.Category, Price_: item.UnitPrice, Qty_: item.quantity.toString)
                cartItemsArr.append(cartItems.toJSON())
            }
        }

        if cartItemsArr.count == 0 {
            return
        }
        
        if let storeModal = storeModal {
            let date = Date().dateConvert(time: Date(), format: DateFormat.date1.id)
            let time = Date().dateConvert(time: Date(), format: DateFormat.date2.id)
            let storeOrdersModal = StoreOrdersModal.init(id_: updateId, name_: txtName?.text?.trimmed(), Title_: "", Desc_: "", ContactNo_: txtContactNo?.text, pickUpAddress_: storeModal.address, dropAddress_: txtAddress?.text?.trimmed(), Status_: "Open", UserID_ : self.UserID, date_: date, time_: time, SaveAddress_: true, LandMarkDropAddress_: lblLandMark?.text?.trimmed(), Price_: totalCost?.toString , StoreID_ : /storeModal.id , cartItems_ : cartItemsArr , CityCode_: "")
            self.storeOrderModal = storeOrdersModal
            PriceCalculationDetails()
        }
    }
    
    func handle(response : Response){
        switch response {
        case .success(let obj):
           
            if let modal = obj as? [PriceCalculationModal]{
                for(_, value) in modal.enumerated() {
                    
                    switch /value.itemTitle {
                    case "GST":
                    tax = value.itemValue?.toDouble()
                    
                    case "RatePerKM":
                    pricePerKm = value.itemValue?.toDouble()
                    
//                    case "SurpriseRanges":
//                    walletAmt = value.itemValue?.toDouble()
                    
                    default:
                        continue
                    }
                }
               navigateToPaymentVC()
            }
            
            break
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
        Utility.shared.stopLoader()
    }
    
    func navigateToPaymentVC() {
        
        guard let tax = self.tax , let pricePerKm = self.pricePerKm  else {
            print("tax & price perkm & wallet amt is nil from the api please check")
            return
        }
        
        guard  let sourcePoint = self.sourcePoint else {
            Messages.shared.show(alert: .oops, message: "Please enter Landmark", type: .warning)
            return
        }
        
        updateToModal()
        guard let paymentVC = R.storyboard.home.paymentViewController() else{
            return
        }
        paymentVC.totalCost = self.totalCost
        paymentVC.storeModal = self.storeModal
        paymentVC.storeOrderModal = self.storeOrderModal
        paymentVC.tax = tax
        paymentVC.sourcePoint = sourcePoint
        paymentVC.pricePerKm = pricePerKm
        self.pushVC(paymentVC)
    }
    
    
    func updateToModal(){
        
        guard let userDetails = UDKeys.UserDTL.fetch() as? UserDetails else {
            return
        }
        
        userDetails.address = txtAddress?.text?.trimmed()
        userDetails.landMark = lblLandMark?.text?.trimmed()
        userDetails.latitude = sourcePoint?.coordinate.latitude
        userDetails.longitude = sourcePoint?.coordinate.longitude
        UDKeys.UserDTL.save(userDetails)
    }
}

extension CommunicationAddressViewController  {
    
//    override func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtLandMark {
//            currentTextField = textField
//            showGooglePicker()
//        }
//     }
    
    //MARK: - Move to Google Search
    func showGooglePicker() {
        
        autoCompleteDelegate = GoogleAutoCompleteDelegate(placePickerVC: self.controller)
        controller.tableCellBackgroundColor = .white
        controller.delegate = self.autoCompleteDelegate
        autoCompleteDelegate?.applyFilter(with: .address)
        self.present(controller, animated: true, completion: nil)
        
        /// display autocomplete
        autoCompleteDelegate?.show(selectedLocation: { (place) in
            debugPrint("Selected Location:" , place.addressComponents)
            print("Place name: \(/place.name)")
            print("Place ID: \(/place.placeID)")
            print("Place lat : \(place.coordinate.latitude) , long : \(place.coordinate.longitude)")
            self.sourcePoint = MKMapPoint(place.coordinate)
            self.lblLandMark?.text = /place.formattedAddress
        }, cancelled: {})
    }
    
}

extension CommunicationAddressViewController {
    
    func PriceCalculationDetails(){
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.getConfigurations(cityCode: /self.storeModal?.CityCode)) { [weak self](response) in
            self?.handle(response : response)
        }
    }
}

