//
//  CurrentLocationViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 11/11/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
protocol LocationChangeDelegate: AnyObject {
    func locationChanged()
}

class CurrentLocationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtCity : UITextField?
//    @IBOutlet weak var bottomViewHeightConstraint : UITextField?
    @IBOutlet weak var deliveryView: UIView!
//    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var anatapurRadio: UIImageView!
    @IBOutlet weak var kurnoolRadio: UIImageView!
    @IBOutlet weak var tadipatri: UIImageView!
    
    @IBOutlet weak var anatapurStack: UIStackView!
    @IBOutlet weak var kurnoolStack: UIStackView!
    @IBOutlet weak var tadipatriStack: UIStackView!
    
    @IBOutlet weak var CityStack: UIStackView!
    @IBOutlet weak var proceedButton: UIButton!
    
    var autoCompleteDelegate: GoogleAutoCompleteDelegate?
    weak var locationChangeDelegate : LocationChangeDelegate?
    let controller = GMSAutocompleteViewController()
    var cordinate = CLLocationCoordinate2D()
    var isCurrentLocationUsed : Bool = false
    
    var cityNames: [String] = ["Anantapur", "Kurnool", "Tadipatri"]
    var cities: [String: [Double]] = ["Anantapur": [14.6819, 77.6006] , "Kurnool": [15.8281, 78.0373] , "Tadipatri": [14.9091, 78.0092]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentLocationViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentLocationViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        anatapurRadio.image = UIImage(named: "radio_button_unfilled")
        kurnoolRadio.image = UIImage(named: "radio_button_unfilled")
        tadipatri.image = UIImage(named: "radio_button_unfilled")
        
        let anantapur = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        let kurnool = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        let tadipatri = UITapGestureRecognizer(target: self, action: #selector(hidingButton_imageChange(_:)))
        
        self.anatapurStack.isUserInteractionEnabled = true
        self.anatapurStack.addGestureRecognizer(anantapur)
        
        self.kurnoolStack.isUserInteractionEnabled = true
        self.kurnoolStack.addGestureRecognizer(kurnool)
        
        self.tadipatriStack.isUserInteractionEnabled = true
        self.tadipatriStack.addGestureRecognizer(tadipatri)
        
        proceedButton.isUserInteractionEnabled = false
        proceedButton.backgroundColor = .lightGray
        proceedButton.alpha = 0.5
//        cityTableView.del//e = self
    }
    
    @objc func hidingButton_imageChange(_ sender: UITapGestureRecognizer) {
        
        guard let tag = sender.view?.tag else { return }
        
        switch tag {
            
        case 0:
                    
            anatapurRadio.image = UIImage(named: "radio_btn_filled")
            kurnoolRadio.image = UIImage(named: "radio_button_unfilled")
            tadipatri.image = UIImage(named: "radio_button_unfilled")
            
            retriveData(tag: tag)
            
            break
            
        case 1:
            
            anatapurRadio.image = UIImage(named: "radio_button_unfilled")
            kurnoolRadio.image = UIImage(named: "radio_btn_filled")
            tadipatri.image = UIImage(named: "radio_button_unfilled")
            
            retriveData(tag: tag)
            
            break
            
        case 2:
            
            anatapurRadio.image = UIImage(named: "radio_button_unfilled")
            kurnoolRadio.image = UIImage(named: "radio_button_unfilled")
            tadipatri.image = UIImage(named: "radio_btn_filled")
            
            retriveData(tag: tag)
        
            break
            
        default:
            
            anatapurRadio.image = UIImage(named: "radio_button_unfilled")
            kurnoolRadio.image = UIImage(named: "radio_button_unfilled")
            tadipatri.image = UIImage(named: "radio_button_unfilled")
        }
    }
    
    @IBAction func btnProceedAct(_ sender : UIButton){
        updateLocalDB()
    }
    
    @IBAction func btnCurrentLocationAct(_ sender : UIButton){
        
        LocationManager.shared.updateUserLocation()
        LocationManager.shared.fetchLocationWithCompletionHandler { [weak self](lat, long, city) in
            
            guard let self = self else { return }
            if let lat = lat, let long = long, let city = city {
                
                UDKeys.CurrentLat.save(lat)
                UDKeys.CurrentLong.save(long)
                UDKeys.CurrentCity.save(city)
                
                self.isCurrentLocationUsed = true
                self.updateLocalDB()
            }
        }
        
    }
    
    
    func updateLocalDB() {
        
        if /isCurrentLocationUsed {
            
            UDKeys.UsedLat.remove()
            UDKeys.UsedLong.remove()
            UDKeys.UsedCity.remove()
        }
        else {
            
            if /self.txtCity?.text?.isEmpty {
                Messages.shared.show(alert: .oops, message: "Please enter city to proceed", type: .warning)
                return
            }
            
            else {
                
                UDKeys.UsedLat.save(self.cordinate.latitude)
                UDKeys.UsedLong.save(self.cordinate.longitude)
                UDKeys.UsedCity.save(/self.txtCity?.text)
                
//                UDKeys.CurrentLat.remove()
//                UDKeys.CurrentLong.remove()
//                UDKeys.CurrentCity.remove()
            }
        }
        
        locationChangeDelegate?.locationChanged()
        self.dismiss(animated: true, completion: nil)
    }
    
    func retriveData(tag: Int) {
        
        self.txtCity?.text = cityNames[tag]
        
        self.cordinate.latitude = cities[cityNames[tag]]?[0] ?? 0.0
        self.cordinate.longitude = cities[cityNames[tag]]?[1] ?? 0.0
        
        proceedButton.isUserInteractionEnabled = true
        proceedButton.alpha = 1.0
        proceedButton.backgroundColor = UIColor(hexString: "C0CF2C")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch: UITouch? = touches.first

        switch touch?.view {
            
        case self.deliveryView: do {
            
            return
        }
        case self.CityStack: do {
            
            return
        }
        case self.anatapurStack: do {
            
            return
        }
        case self.kurnoolStack: do {
        
            return
        }
        case self.tadipatriStack: do {
            
            return
        }
        default:
            
            guard let _ = UDKeys.CityCode.fetch() else { return  }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableCell", for: indexPath) as! CityTableCell
        
//        var result = Array(cities.keys)

        cell.model = cityNames[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.txtCity?.text = cityNames[indexPath.row]
        
        self.cordinate.latitude = cities[cityNames[indexPath.row]]?[0] ?? 0.0
        self.cordinate.longitude = cities[cityNames[indexPath.row]]?[1] ?? 0.0
//        UIView.animate(withDuration: 0.3, delay: 0) {
//            self.cityTableView.isHidden = true
//        }
        updateLocalDB()
    }
}

extension CurrentLocationViewController {

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


extension CurrentLocationViewController  {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
       
        anatapurRadio.image = UIImage(named: "radio_button_unfilled")
        kurnoolRadio.image = UIImage(named: "radio_button_unfilled")
        tadipatri.image = UIImage(named: "radio_button_unfilled")
        
        if textField == txtCity {
            showGooglePicker()
        }
    }
    
    //MARK: - Move to Google Search
    func showGooglePicker() {
        
        if !(controller.isBeingPresented) {
            
            autoCompleteDelegate = GoogleAutoCompleteDelegate(placePickerVC: self.controller)
            controller.tableCellBackgroundColor = .white
            controller.delegate = self.autoCompleteDelegate
            autoCompleteDelegate?.applyFilter(with: .city)
            self.present(controller, animated: true, completion: nil)
            
            /// display autocomplete
            autoCompleteDelegate?.show(selectedLocation: { [weak self](place) in
                
                guard let self = self else { return }

                print("Place name: \(/place.name)")
                print("Place ID: \(/place.placeID)")
                self.cordinate = place.coordinate
                self.isCurrentLocationUsed = false
                print("Place lat : \(place.coordinate.latitude) , long : \(place.coordinate.longitude)")
                self.txtCity?.text = /place.name
                
                self.proceedButton.isUserInteractionEnabled = true
                self.proceedButton.alpha = 1.0
                self.proceedButton.backgroundColor = UIColor(hexString: "C0CF2C")
                
            }, cancelled: {})
        }
    }
}

class CityTableCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var model : String? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        
        label.text = model
    }
    
}
