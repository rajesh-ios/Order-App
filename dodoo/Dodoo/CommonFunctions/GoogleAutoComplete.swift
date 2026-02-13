//
//  GoogleAutoComplete.swift
//  Wethaq
//
//  Created by OSX on 21/02/18.
//  Copyright © 2018 codebrew. All rights reserved.
//

import UIKit
import GooglePlaces

typealias LocationSelected = (_ place: GMSPlace) -> ()
typealias Cancelled = () -> ()

class GoogleAutoCompleteDelegate: NSObject, GMSAutocompleteViewControllerDelegate {
    
    //MARK: - Variables
    var placePickerVC: GMSAutocompleteViewController?
    var locationSelected: LocationSelected?
    var cancelled:Cancelled?
    
    init(placePickerVC: GMSAutocompleteViewController) {
        
        self.placePickerVC = placePickerVC
    
    }
    
    //MARK:- Apply Filter
    func applyFilter(with filter: GMSPlacesAutocompleteTypeFilter ) {
//        let filterObject = GMSAutocompleteFilter()
//        filterObject.type = filter
//        placePickerVC?.autocompleteFilter = filterObject
        
        /// country wise
        let newFilter = GMSAutocompleteFilter()
        newFilter.country = "IN"
        newFilter.type = filter
        placePickerVC?.autocompleteFilter = newFilter
        
    }
    
    //MARK: - Show AutoComplete
    func show(selectedLocation: @escaping LocationSelected, cancelled: @escaping Cancelled){
        
        self.locationSelected = selectedLocation
        self.cancelled = cancelled
    }
    
    //MARK: - Selection Action
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // locaiton selected listener
        if let selected = self.locationSelected {
            selected(place)
        }
        
        // dismiss autocomplete picker
        self.placePickerVC?.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Cancelled Action
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        // cancelled listener
        if let cancelled = self.cancelled {
            cancelled()
        }
        placePickerVC?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Failed
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error: " , error.localizedDescription)
    }
}
