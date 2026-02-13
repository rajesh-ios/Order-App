
import UIKit
import GooglePlaces
import GoogleMaps
import Foundation
//import EZSwiftExtensions

class MapViewController : BaseViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var searchBar : UISearchBar?
//    var tableDataSource: GMSAutocompleteTableDataSource?
//    var searchDisplayController: UISearchController?
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
        openAutoCompleteList()
    }
    
    func onViewDidLoad() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
    }
    
    func openAutoCompleteList() {
        let autocompleteController = GMSAutocompleteViewController()
//        self.selectListAddress = selectListAddress
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
    
    
//    // Present the Autocomplete view controller when the button is pressed.
//     func autocompleteClicked() {
//        let autocompleteController = GMSAutocompleteViewController()
//        autocompleteController.delegate = self
//
//        // Specify the place data types to return.
//        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
//            UInt(GMSPlaceField.placeID.rawValue))!
//        autocompleteController.placeFields = fields
//
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter
//
//        // Display the autocomplete view controller.
//        present(autocompleteController, animated: true, completion: nil)
//    }
//
}

extension MapViewController : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismissVC(completion: nil)
        ez.topMostVC?.dismissVC(completion: nil)
        print("Place name: \(/place.name)")
        print("Place ID: \(/place.placeID)")
        print("Place attributions: \(place.attributions ?? nil)")
       
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        ez.topMostVC?.dismissVC(completion: nil)
        self.dismissVC(completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


// Handle the user's selection.
extension MapViewController : GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
//        searchController?.isActive = false
        // Do something with the selected place.
        
        print("Place name: \(/place.name)")
        print("Place address: \(/place.formattedAddress)")
        print("Place attributions: \(place.attributions ?? nil)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
}

//extension MapViewController: GMSAutocompleteTableDataSourceDelegate {
//    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWithPlace place: GMSPlace) {
//        searchDisplayController?.active = false
//        // Do something with the selected place.
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//    }
//
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
//        tableDataSource?.sourceTextHasChanged(searchString)
//        return false
//    }
//
//    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: NSError) {
//        // TODO: Handle the error.
//        print("Error: \(error.description)")
//    }
//
//    func tableDataSource(tableDataSource: GMSAutocompleteTableDataSource, didSelectPrediction prediction: GMSAutocompletePrediction) -> Bool {
//        return true
//    }
//}
