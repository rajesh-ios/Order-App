//
//  Utility.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/16/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit
//import EZSwiftExtensions
import GooglePlacePicker
import CoreLocation


typealias success = (_ coordinates: CLLocationCoordinate2D, _ fullAddress: String?, _ name : String?, _ city : String?,_ state : String?, _ subLocality: String?, _ postalCode : String? ,_ country : String? ) -> ()


class Utility : NSObject , GMSPlacePickerViewControllerDelegate {
    
    
    static let shared = Utility()
    var loaderView : UIView?
     var responseBack : success?
     let geoCoder = CLGeocoder()
    func  startLoader() {
        loaderView = LoaderView.instanceFromNib()
        if let frame = UIApplication.shared.keyWindow?.frame {
            loaderView?.frame = frame
        }
        (loaderView as? LoaderView)?.imgView?.image = UIImage.gifImageWithName(name: "gif_character")
        if let loaderView = loaderView {
            UIApplication.shared.keyWindow?.addSubview(loaderView)
        }
    }
    
    override init() {
        super.init()
        LocationManager.shared.updateUserLocation()
    }
    
    func stopLoader() {
         loaderView?.removeFromSuperview()
        loaderView = nil
    }
    
    func getPlacePicker(responseBlock : @escaping success){
        
        responseBack = responseBlock
        let placePicker = GMSPlacePickerViewController(config: GMSPlacePickerConfig(viewport: nil))
        placePicker.delegate = self
        ez.topMostVC?.presentVC(placePicker)
    
    }
    
    func getAttributedString(firstStr : String? , firstAttr : [NSAttributedString.Key : Any]? , secondStr : String? , secondAttr : [NSAttributedString.Key : Any]?) -> NSMutableAttributedString{
        
        let attributedString1 = NSMutableAttributedString(string: /firstStr, attributes:firstAttr)
        let attributedString2 = NSMutableAttributedString(string: /secondStr, attributes: secondAttr)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        
        ez.topMostVC?.dismissVC(completion: nil)
        
        if let address = place.formattedAddress,let components = place.addressComponents{
            var city,state ,postalCode, country ,subLocality : String?
            for component in components {
                if component.type == "city" || component.type == "postal_town" || component.type == "locality"{
                    city = component.name
                }
                if component.type == "state" || component.type == "administrative_area_level_1" || component.type == "administrative_area_level_2"{
                    state = component.name
                }
                if component.type == "country" {
                    country = component.name
                }
                
                if component.type == "postal_code"{
                    postalCode = component.name
                }
                
                if component.type == "sublocality_level_1"{
                    subLocality = component.name
                }
            }
            responseBack?(place.coordinate, address , place.name, city,state,subLocality,postalCode,country)
        }else{
            
            calculateAddress(lat: place.coordinate.latitude, long: place.coordinate.longitude, responseBlock: {(coordinates, fullAddress,name,city,state,subLocality,postalCode,country ) in
                self.responseBack?(coordinates, fullAddress, name, city,state,subLocality,postalCode,country)
            })
        }
        
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        ez.topMostVC?.dismissVC(completion: nil)
    }
    
    //MARK::- Calculate address using cordinates
    func calculateAddress(lat : CLLocationDegrees , long : CLLocationDegrees , responseBlock : @escaping success)
    {
        
        geoCoder.reverseGeocodeLocation( CLLocation(latitude: lat, longitude: long), completionHandler: { (placemarks, error) -> Void in
            
            let placeMark = placemarks?[0]
            guard let address = placeMark?.administrativeArea else {return}
            
            let fullAddress = address
            let name = placeMark?.name
//            let city = placeMark?.subAdministrativeArea
            let city = placeMark?.locality
            let state = placeMark?.administrativeArea
            let subLocality = placeMark?.subLocality
            let country = placeMark?.country
            let postalCode = placeMark?.postalCode
            responseBlock(CLLocationCoordinate2D(latitude: lat, longitude: long), fullAddress,name,city,state,subLocality,postalCode,country)
        })
        
    }
    
    //MARK: Location Function
    func stringToDate(_ dateString: String? , _ withFormat : String?) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let date = inputFormatter.date(from: /dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = withFormat
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func strToDate(_ strDate : String? , inputFormat : String? = "h:mm a") -> Date?{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        if let date = inputFormatter.date(from: /strDate){
            return date
        }
        return nil
    }
    
}
