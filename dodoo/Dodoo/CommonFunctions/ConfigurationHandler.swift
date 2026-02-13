//
//  ConfigurationHandler.swift
//  Dodoo
//
//  Created by Apple on 13/08/21.
//  Copyright © 2021 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation

typealias SuccessHandler = (_ gstForStore : Double? , _ gstForPickUp : Double? , _ ratePerKm : Double? , _ deliveryChargesForStore : Double? , _ deliveryChargesfromPickUp : Double? , _ error : String?) -> ()

class ConfigurationHandler : NSObject {
    
    override init() {
        
    }
    
    class func getConfiguration(cityCode : String? , completion : @escaping SuccessHandler) {
        guard  let cityCode = cityCode  else {
            print("CityCode is nil")
            return
        }
        APIManager.shared.request(with: HomeEndpoint.getConfigurations(cityCode: cityCode)) {(response) in
            self.handle(response: response) { taxForStore, taxforPickUpandDrop, pricePerKm, deliveryForStore , deliveryforPickup,error in
                completion(taxForStore,taxforPickUpandDrop , pricePerKm,deliveryForStore , deliveryforPickup , error)
            }
        }
    }
     
    
    class func handle(response : Response , handler : @escaping SuccessHandler){
        switch response {
        case .success(let obj):
            var taxForStore , taxForPickUpandDrop , pricePerKm , deliveryChargesForStore , deliveryChargesfromPickUp : Double?
            if let modal = obj as? [PriceCalculationModal]{
                for(_, value) in modal.enumerated() {
                    // Please check the api response at the end.
                    switch /value.itemTitle {
                    case "GST":
                        taxForStore = value.itemValue?.toDouble()
                        
                    case "RatePerKM":
                        pricePerKm = value.itemValue?.toDouble()
                    case "StoreMinAmount":
                        deliveryChargesForStore = value.itemValue?.toDouble()
                    case "MinAmount":
                        deliveryChargesfromPickUp = value.itemValue?.toDouble()
                    case "pdpGST":
                        taxForPickUpandDrop = value.itemValue?.toDouble()
                    //                    case "SurpriseRanges":
                    //                    walletAmt = value.itemValue?.toDouble()
                    
                    default:
                        continue
                    }
                }
                handler(taxForStore ,taxForPickUpandDrop ,pricePerKm , deliveryChargesForStore , deliveryChargesfromPickUp , nil)
            }
            
            break
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
            handler(nil,nil, nil , nil , nil , R.string.localize.somethingWentWrong())
        }
    }
    
}
