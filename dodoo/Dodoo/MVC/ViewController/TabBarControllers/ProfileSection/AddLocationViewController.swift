//
//  AddLocationViewController.swift
//  Dodoo
//
//  Created by Banka Rajesh on 08/09/22.
//  Copyright © 2022 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps

protocol AddLocationControlDelegate {

    func passLocationData(location: String, address1: String, address2: String, city: String, zipCode: String, coordinates: CLLocationCoordinate2D)
}

class AddLocationViewController: BaseViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapAddress: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var curentLocationView: UIView!
    @IBOutlet weak var savecancleView: UIView!
    @IBOutlet weak var curretLocationButton: UIButton!

    @IBOutlet weak var markerView: UIImageView!
    
    var location: String = ""
    var address1: String = ""
    var address2: String = ""
    var zipCode: String = ""
    var city: String?
        
    var delegate: AddLocationControlDelegate?
        
    var markerPosition: CLLocationCoordinate2D?
    var mapMarker = GMSMarker()
        
    var locationManager: LocationManager = LocationManager()
    var currencLocation: Bool = true
    
    var zoom: Float = 18.0
    var currentCordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.mapMarker.isDraggable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpMapDefaultData()
        
        mapView.addSubview(markerView)
    }
    
    func setUpMapDefaultData() {
        
        if location.count > 0 {
            
            currencLocation = false
            mapAddress.text = location
            setUpMarkerCameraPosition()
        }
        else {
            
            self.currencLocation = true
            self.markerPosition = nil
            self.setUpUserLocation()
        }
    }

    @IBAction private func searchPlacesTapped(sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |

                                                  UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.phoneNumber.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.country = "IN"
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func saveLocationClicked(_ sender: UIButton) {
        
        guard let currentCordinate = currentCordinate else {
            return
        }
        
        delegate?.passLocationData(location: location, address1: address1, address2: address2, city: city ?? "", zipCode: zipCode,coordinates: currentCordinate)
        
        self.dismiss(animated: true)
    }
    
    @IBAction func currentLocationClicked(_ sender: UIButton) {
           
        if currencLocation == false {

            self.markerPosition = nil
            setUpUserLocation()
        }
        else {
            
            curretLocationButton.setImage(UIImage(named: "toggleoff"), for: .normal)
            currencLocation = false
        }
    }
    
    private func setUpUserLocation() {
        
        locationManager.googleMaps = mapView

        self.currencLocation = true
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: self.savecancleView.bounds.height + 30, right: 0)

            
        self.curretLocationButton.setImage(UIImage(named: "toggleon"), for: .normal)
        
        
        if currencLocation {
            
            if let lat = UDKeys.CurrentLat.fetch(), let long = UDKeys.CurrentLong.fetch() {
                
                getCurrentLocation(coordinate: CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees))
                self.setUpMarkerCameraPosition()
            }
            
        }
        else {
            
            if let currentCordinate = currentCordinate {
                
                getCurrentLocation(coordinate: currentCordinate)
            }
        }
        self.setUpMarkerCameraPosition()
    }
    
    private func getCurrentLocation(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let error = error {
                print("Unable to get address",error)
            }
            
            self.currentCordinate = coordinate
            print(coordinate)
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]

                let currentAddress = lines.joined(separator: "\n")
                
                
                self.location = currentAddress
                self.zipCode = address.postalCode ?? ""
                
                self.city = address.locality
                if let address2 = address.subLocality {
                    
                    self.address2 = address2
                }
                
                self.mapAddress.text = currentAddress
                self.zoom = 18.0
                
            }
            
            if self.currencLocation {
                
                self.setUpMarkerCameraPosition()
            }
        }
    }
    
    func setUpMarkerCameraPosition() {
        
        if let currentCordinate = currentCordinate {
            
            let camera = GMSCameraPosition.camera(withTarget: currentCordinate, zoom: zoom)

            self.mapView.camera = camera
        }
        
    }
}

extension AddLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
         if self.markerPosition == nil{
            self.markerPosition = position.target

         }else{
            self.markerPosition = position.target
            currencLocation = false
         }
        
        self.zoom = mapView.camera.zoom
     }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        if currencLocation == false {
            
            curretLocationButton.setImage(UIImage(named: "toggleoff"), for: .normal)
        }
        else {
            curretLocationButton.setImage(UIImage(named: "toggleon"), for: .normal)
            currencLocation = true
        }
        
        self.getCurrentLocation(coordinate: cameraPosition.target)
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {

        self.markerPosition = nil
        self.zoom = 18
        setUpUserLocation()
        return true
    }
}

extension AddLocationViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        guard let addressComponents = place.addressComponents else { return }
        
        currentCordinate = place.coordinate
        
        for addressComponent in addressComponents {
            
            if addressComponent.types[0] == "locality" {
                
                self.city = addressComponent.name
            }
            else if addressComponent.types[0] == "sublocality_level_1" {
                
                self.address1 = addressComponent.name
            }
            else if addressComponent.types[0] == "sublocality_level_2" {
                
                self.address1 = addressComponent.name
            }
            else if addressComponent.types[0] == "postal_code" {
                
                self.zipCode = addressComponent.name
            }
        }
        
        dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                
                self.location = place.formattedAddress!
                self.mapAddress.text = place.formattedAddress
                self.zoom = 18.0
                self.setUpMarkerCameraPosition()

                self.currencLocation = false
                self.curretLocationButton.setImage(UIImage(named: "toggleoff"), for: .normal)
                self.mapView.isMyLocationEnabled = false
                self.mapView.settings.myLocationButton = false
                
            }
        }
        )
      }

      func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
      }

      // User canceled the operation.
      func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
      }

      // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
}

