//
//  LocationManager.swift
//  Dodoo
//
//  Created by Shubham Dhingra on 29/09/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager = CLLocationManager()
    var currentLoc : CLLocation?
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var address : String?
    var name : String?
    var city : String? {
        didSet {
            
        }
    }
    var postalCode : String?
    var country : String?
    var state : String?
    
    var locationManagerCallback: ((Double?, Double?, String) -> ())?
    
    public var googleMaps: GMSMapView?

    
    override init() {
        super.init()
        locationInitializer()
//        updateLocation()
    }
    
    static let shared = LocationManager()
    
    func updateUserLocation(){
        locationInitializer()
//        updateLocation()
    }
    
//    func updateLocation(){
//        locationManager?.delegate = self
//    }
    
    func locationInitializer(){

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            callUserAuthorization()
        case .restricted,.denied:
            settingsAlert()
        }
    }
    func callUserAuthorization(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func settingsAlert(){
        
        AlertsClass.shared.showAlertController(withTitle: R.string.localize.settings(), message: R.string.localize.settingsLocationApp(), buttonTitles: [R.string.localize.settings()]) { (value) in
            let type = value as AlertTag
            switch type {
            case .yes:
                CameraGalleryPickerBlock.shared.openSettings()
            default:
                return
            }
        }
    }
    
    func fetchLocationWithCompletionHandler(completion: @escaping(Double?, Double?,String?) -> ()) -> Void {
        locationManagerCallback = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLoc = locations.last
        if let lat = currentLoc?.coordinate.latitude ,let lng = currentLoc?.coordinate.longitude {
            latitude = lat
            longitude = lng
            
            UDKeys.CurrentLat.save(lat)
            UDKeys.CurrentLong.save(lng)
            Utility.shared.calculateAddress(lat: lat, long: lng, responseBlock: {[weak self] (coordinates, address,name,city,state,subLocality,postalCode,country) in
                
                self?.name = name
                self?.address = address
                self?.city = city
                if let currentCity = city{
                    UDKeys.CurrentCity.save(currentCity)
                    self?.locationManagerCallback?(lat,lng,currentCity)
                }
                self?.state = state
                self?.country = country
                self?.postalCode = postalCode
                self?.locationManager.stopUpdatingLocation()
                
                self?.locationManager.delegate = nil
            
            })
        }
   }
    
    func getFullAddress() -> String? {
        
        var completeAddress : String?
        if let name = self.name{
            completeAddress = name
        }
        if let city = self.city{
            completeAddress = /completeAddress + "," + city
        }
        if let state = self.state {
            completeAddress = /completeAddress + "," + state
        }
        
        if let postalCode = self.postalCode {
            completeAddress = /completeAddress + " " + postalCode
        }
        
        if let country = self.country {
            completeAddress = /completeAddress + "," + country
        }
        return /completeAddress
    }
    
    public func setUpGoogleMapView() {
        guard let googleMapView = self.googleMaps else {
            return
        }
        googleMapView.settings.myLocationButton = true
        googleMapView.settings.compassButton = true
        googleMapView.isMyLocationEnabled = true
        
        self.locationManager.requestLocation()
    }
    
}

