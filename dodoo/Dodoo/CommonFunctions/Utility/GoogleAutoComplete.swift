//
//  GoogleAutoComplete.swift
//  Dodoo
//
//  Created by Shubham on 18/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import GooglePlaces
import  EZSwiftExtensions
import  UIKit
import GoogleMaps
import CoreLocation


typealias PlacesAutoCompleteData = (_ placeName : String , _ placeID : String , _ attributions : NSAttributedString?) -> ()

class GoogleAutoComplete : NSObject , GMSAutocompleteViewControllerDelegate {
    
    static let shared = GoogleAutoComplete()
    var selectListAddress : PlacesAutoCompleteData?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?

    
    override init() {
        super.init()
//        autocompleteController.delegate = self
    }
    
    
    
    func openAutoCompleteList(selectListAddress : @escaping PlacesAutoCompleteData) {
        let autocompleteController = GMSAutocompleteViewController()
        self.selectListAddress = selectListAddress
        autocompleteController.delegate = self
        openGMSController(autocompleteController: autocompleteController)
    }
    
    
    func openGMSController(autocompleteController : GMSAutocompleteViewController) {
        //         Specify the place data types to return.
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "IN"
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        ez.topMostVC?.present(autocompleteController, animated: true, completion: nil)
        
        
    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(/place.name)")
        print("Place ID: \(/place.placeID)")
        print("Place lat : \(place.coordinate.latitude) , long : \(place.coordinate.longitude)")
         ez.topMostVC?.dismiss(animated: true, completion: nil)
        if let selectAddress = self.selectListAddress {
            selectAddress(/place.name,/place.placeID ,nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", /error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        ez.topMostVC?.dismiss(animated: true, completion: nil)
        if let selectAddress = self.selectListAddress {
            selectAddress("", "" , nil)
        }
    }
    
}
