//
//  MyAddressesViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 9/26/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation
//import EZSwiftExtensions
import MapKit
import CoreLocation
protocol SelectAddressDelegate: AnyObject {
    func selectAddress(_ address : MyAddressesModal)
}
class MyAddressesViewController: BaseViewController {
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var isFirstTime : Bool = true
    var addressArr = [MyAddressesModal]()
    var totalCost : Int?
    var selectItems : [Items]?
    var storeModal : StoresModal?
    var storeOrderModal : StoreOrdersModal?
    var forProfile : Bool = false
    var selectIndexForOperation : Int = -1
    var updateId : String? = "0"
    var tax : Double?
    var pricePerKm : Double?
    var sourcePoint = MKMapPoint()
    var fromPickUpAndDrop : Bool = false
    weak var selectAddressDelegate : SelectAddressDelegate?
    var deliveryChargefromAPI : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        getAddresses()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddressRecord(_:)), name: .UPDATE_ADDRESS_RECORD, object: nil)
    }
    
    
    @IBAction func btnAddAddressAct(_ sender : UIButton){
        navigateToEditAddressScreen(actions: .Add)
    }
    
    
    @objc func updateAddressRecord(_ notification : NSNotification){
        ez.runThisInMainThread {
            self.getAddresses()
        }
    }
    
    
    func navigateToEditAddressScreen(actions : Actions){
        guard let vc = R.storyboard.main.addAddressViewController() else {
            return
        }
        vc.actions = actions
        if actions == .Edit && self.selectIndexForOperation != -1 {
            vc.model = self.addressArr[self.selectIndexForOperation]
        }
        
        if let _ = self.navigationController {
            
            self.pushVC(vc)
        }
        else {
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: .UPDATE_ADDRESS_RECORD, object: nil)
    }
}


extension MyAddressesViewController {
    
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: addressArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.nib.myAddressCell.identifier)
        
        tableDataSource?.configureCellBlock = { [weak self](cell, item, indexpath) in
            (cell as? MyAddressCell)?.index = /indexpath?.row
            (cell as? MyAddressCell)?.model = item
            (cell as? MyAddressCell)?.delegate = self
        }
        tableDataSource?.aRowSelectedListener = { [weak self](indexpath,cell) in
            
            guard let self = self else { return }
            if /self.fromPickUpAndDrop  {
                self.selectAddressDelegate?.selectAddress(self.addressArr[indexpath.row])
                self.popVC()
                self.dismiss(animated: false)
            }
            else {
                if self.forProfile {
                    return
                }
                else {
                    self.saveStoreOrders(self.addressArr[indexpath.row])
                }
            }
        }
    }
    
    func reloadTable() {
        tableView.register(R.nib.myAddressCell(), forCellReuseIdentifier: R.nib.myAddressCell.identifier)
        if isFirstTime {
            self.isFirstTime = false
            configureTableView()
        }
        else {
            tableDataSource?.items = self.addressArr
            tableView?.reloadData()
        }
    }
}

extension MyAddressesViewController : ActionOnSelectAddressDelegate {
    func actionOnSelectAddress(_ index: Int, _ actions: String?) {
        
        if index < self.addressArr.count {
            
            self.selectIndexForOperation = index
            if actions == R.string.localize.useAsCurrent() {
                if /self.addressArr[index].isCurrentAddress {
                    return
                }
                updateAddressAsCurrent(selectAddress: self.addressArr[index])
            }
            
            else if actions == R.string.localize.edit() {
                navigateToEditAddressScreen(actions: .Edit)
            }
            else if actions == R.string.localize.delete() {
                deleteAddress(selectAddress: self.addressArr[index])
            }
        }
    }
    
    
}

//MARK::- API to get the list of User Address
extension MyAddressesViewController {
    
    func getAddresses() {
        
        if Utility.shared.loaderView == nil && isFirstTime {
            
            Utility.shared.startLoader()
        }
        
        APIManager.shared.request(with: HomeEndpoint.getAddressesList(Userid: UserID) , isLoader: isFirstTime) {[weak self](response) in
            self?.handleResponse(response: response, responseBack: { (success) in
                self?.handleAddressResponse(response: success , actions : .View)
            })
        }
    }
    
    func handleAddressResponse(response : AnyObject? , actions : Actions){
        
        switch actions {
        case .View:
            if let arr = response as? [MyAddressesModal] {
                self.addressArr = arr
                reloadTable()
            }
        case .Delete , .UseAsCurrent:
            if let regModal = response as? RegisterModal , let status = regModal.Status , let Result = regModal.Result {
                
                if status == "1" && (Result == "Delete Success" || Result == "Update Success"){
                    
                    if actions == .Delete {
                        Messages.shared.show(alert: .success, message: "Address deleted successfully", type: .success)
                        if selectIndexForOperation != -1 {
                            if selectIndexForOperation < self.addressArr.count {
                                self.addressArr.remove(at: selectIndexForOperation)
                                self.reloadTable()
                            }
                        }
                    }
                    
                    if actions == .UseAsCurrent {
                        Messages.shared.show(alert: .success, message: "Updated Successfully", type: .success)
                        if selectIndexForOperation != -1 {
                            if selectIndexForOperation < self.addressArr.count {
                                //                                self.addressArr[selectIndexForOperation].isCurrentAddress = !(/self.addressArr[selectIndexForOperation].isCurrentAddress)
                                self.getAddresses()
                            }
                        }
                    }
                }
                else if status == "0"{
                    Messages.shared.show(alert: .oops, message: Result, type: .warning)
                }
            }
            
        default:
            break
        }
        Utility.shared.stopLoader()
    }
}


//Mark::- Code to save Orders

//MARK::- SAVE STORE ORDERS API
extension MyAddressesViewController {
    func saveStoreOrders(_ address : MyAddressesModal) {
        
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
            
            let completetAddress = /address.DoorNo + ", " + /address.address
            let storeOrdersModal = StoreOrdersModal.init(id_: updateId, name_: address.title, Title_: "", Desc_: "", ContactNo_: address.Mobile, pickUpAddress_: storeModal.address, dropAddress_: completetAddress, Status_: "Open", UserID_ : self.UserID, date_: date, time_: time, SaveAddress_: true, LandMarkDropAddress_: address.DoorNo, Price_: totalCost?.toString , StoreID_ : /storeModal.id , cartItems_ : cartItemsArr , CityCode_: "\(storeModal.CityCode!)_")
            self.storeOrderModal = storeOrdersModal
            //            let location = CLLocationCoordinate2D(latitude: address.Latitude?.toDouble(), longitude: address.Longitude?.toDouble())
            let lat = address.Latitude?.toDouble()
            let longg =  address.Longitude?.toDouble()
            self.sourcePoint = MKMapPoint(CLLocationCoordinate2D(latitude: /lat , longitude: /longg))
            PriceCalculationDetails()
        }
    }
    
    func handle(response : Response){
        switch response {
        case .success(let obj):
            
            if let modal = obj as? [PriceCalculationModal]{
                for(_, value) in modal.enumerated() {
                    // Please check the api response at the end.
                    switch /value.itemTitle {
                    case "GST":
                        tax = value.itemValue?.toDouble()
                        
                    case "RatePerKM":
                        pricePerKm = value.itemValue?.toDouble()
                    case "StoreMinAmount" , "MinAmount":
                        deliveryChargefromAPI = value.itemValue?.toDouble()
                        
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
        
        //        guard  let sourcePoint = self.sourcePoint else {
        //            Messages.shared.show(alert: .oops, message: "Please enter Landmark", type: .warning)
        //            return
        //        }
        
        //        updateToModal()
        guard let paymentVC = R.storyboard.home.paymentViewController() else{
            return
        }
        paymentVC.totalCost = self.totalCost
        paymentVC.storeModal = self.storeModal
        paymentVC.storeOrderModal = self.storeOrderModal
        paymentVC.tax = tax
        paymentVC.deliveryChargesFromAPI = self.deliveryChargefromAPI
        paymentVC.sourcePoint = sourcePoint
        paymentVC.pricePerKm = pricePerKm
        if let _ = self.navigationController {
            
            self.pushVC(paymentVC)
        }
        else {
            
            paymentVC.modalPresentationStyle = .fullScreen
            self.present(paymentVC, animated: false)
        }
    }
    
    
    //    func updateToModal(){
    //
    //        guard let userDetails = UDKeys.UserDTL.fetch() as? UserDetails else {
    //            return
    //        }
    //
    //        userDetails.address = txtAddress?.text?.trimmed()
    //        userDetails.landMark = lblLandMark?.text?.trimmed()
    //        userDetails.latitude = sourcePoint?.coordinate.latitude
    //        userDetails.longitude = sourcePoint?.coordinate.longitude
    //        UDKeys.UserDTL.save(userDetails)
    //    }
}

//extension MyAddressesViewController  {
//
////    override func textFieldDidBeginEditing(_ textField: UITextField) {
////        if textField == txtLandMark {
////            currentTextField = textField
////            showGooglePicker()
////        }
////     }
//
//    //MARK: - Move to Google Search
//    func showGooglePicker() {
//
//        autoCompleteDelegate = GoogleAutoCompleteDelegate(placePickerVC: self.controller)
//        controller.tableCellBackgroundColor = .white
//        controller.delegate = self.autoCompleteDelegate
//        autoCompleteDelegate?.applyFilter(with: .address)
//        self.present(controller, animated: true, completion: nil)
//
//        /// display autocomplete
//        autoCompleteDelegate?.show(selectedLocation: { (place) in
//            debugPrint("Selected Location:" , place.addressComponents)
//            print("Place name: \(/place.name)")
//            print("Place ID: \(/place.placeID)")
//            print("Place lat : \(place.coordinate.latitude) , long : \(place.coordinate.longitude)")
//            self.sourcePoint = MKMapPoint(place.coordinate)
//            self.lblLandMark?.text = /place.formattedAddress
//        }, cancelled: {})
//    }
//
//}

extension MyAddressesViewController {
    
    func PriceCalculationDetails(){
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.getConfigurations(cityCode: /self.storeModal?.CityCode)) { [weak self](response) in
            self?.handle(response : response)
        }
    }
}



//MARK::- API to delete user address

extension MyAddressesViewController {
    func deleteAddress(selectAddress: MyAddressesModal){
        let modal = MyAddressesModal(UserId: UserID, AddressId: selectAddress.Addressid)
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.deleteAddress(details: modal.toJSON()) , isLoader: true) {[weak self](response) in
            self?.handleResponse(response: response, responseBack: { (success) in
                self?.handleAddressResponse(response: success, actions: .Delete)
            })
        }
    }
}

extension MyAddressesViewController {
    
    func updateAddressAsCurrent(selectAddress: MyAddressesModal){
        selectAddress.isCurrentAddress = !(/selectAddress.isCurrentAddress)
        selectAddress.UserID = UserID
        //        let modal = MyAddressesModal(UserId: UserID, AddressId: selectAddress.Addressid , isCurrentAddress: !(/selectAddress.isCurrentAddress))
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.addOrUpdateAddress(details: selectAddress.toJSON()) , isLoader: true) {[weak self](response) in
            self?.handleResponse(response: response, responseBack: { (success) in
                self?.handleAddressResponse(response: success, actions: .UseAsCurrent)
            })
        }
    }
}


//http://3.129.128.96:1234/MyService.svc/GetConfigurationsByCity/TDP
//[:]
//API Response Time :3.651764988899231
//[
//  {
//    "id" : "602b656295d28216b86f5420",
//    "ItemValue" : "8",
//    "UnitMeasure" : "Percentage",
//    "ItemTitle" : "GST"
//  },
//  {
//    "id" : "602b657095d28216b86f5421",
//    "ItemValue" : "10",
//    "UnitMeasure" : "KM",
//    "ItemTitle" : "RatePerKM"
//  },
//  {
//    "id" : "602b658095d28216b86f5422",
//    "ItemValue" : "42",
//    "UnitMeasure" : "Rupees",
//    "ItemTitle" : "MinAmount"
//  },
//  {
//    "id" : "602b745d95d28216b86f5424",
//    "ItemValue" : "35",
//    "UnitMeasure" : "Rupees",
//    "ItemTitle" : "StoreMinAmount"
//  },
//  {
//    "id" : "602b86cc2544cd0facbd6eab",
//    "ItemValue" : "18",
//    "UnitMeasure" : "Percentage",
//    "ItemTitle" : "pdpGST"
//  }
//]
