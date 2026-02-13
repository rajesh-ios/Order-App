//
//  APIHandler.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Dhingra. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

enum ResponseKeys : String {
    case data
    
}

extension LoginEndpoint {
    
    func handle(data : Any) -> AnyObject? {
        
        // let parameters = JSON(data)
        switch self {
        
        
        case .supportFeedback(_), .register(_):
            let object = Mapper<ParentResponseModal>().map(JSONObject: data)
            return object
            
        case .forgotPassword(_) , .changePassword(_) , .saveSubscriptionAndPickUpDrop(_) , .validateMobileNo(_) , .validateUser(_):
            let object = Mapper<RegisterModal>().map(JSONObject: data)
            return object
            
        case .authentication(_):
            let object = Mapper<UserDetails>().map(JSONObject : data)
            return object
            
        case .getAdvertisement(_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var advArr = [String]()
            for element in arr {
                advArr.append(element.description)
                }
            return advArr as? AnyObject
            
        case .allOrders(_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var ordersArr = [OrdersModal]()
            for element in arr {
                let orders = OrdersModal.init(json: element)
                ordersArr.append(orders)
            }
            return ordersArr as? AnyObject
            
        case .getOrderDetails(_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var ordersArr = [OrderDetailModal]()
            for element in arr {
                let orders = OrderDetailModal.init(fromJson: element)
                ordersArr.append(orders)
            }
            return ordersArr as? AnyObject
            
        case .getNotification(_):
            
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var notiArr = [NotificationModal]()
            for element in arr {
                let orders = NotificationModal.init(fromJson: element)
                notiArr.append(orders)
            }
            return notiArr as? AnyObject
            
        case .getAppVersion:
            let object = Mapper<VersionModal>().map(JSONObject: data)
            return object

        default :
            return "" as? AnyObject
        }
    }
}


extension HomeEndpoint {
    
    func handle(data : Any) -> AnyObject?
    {
//         let parameters = JSON(data)
        
        switch self {
       
        case .updateOrderStatus(_) , .deleteAddress(_) , .addOrUpdateAddress(_)  , .rateOrder(_):
            let object = Mapper<RegisterModal>().map(JSONObject: data)
            return object
            
        case .getWalletInfo(_):
            let json = JSON(data)
            return json["Result"].stringValue as AnyObject
            
        case .getCategories(_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var ordersArr = [OrdersModal]()
            for element in arr {
                let orders = OrdersModal.init(json: element)
                ordersArr.append(orders)
            }
            return ordersArr as AnyObject
            
        case .getStores(_,_) ,.searchStore(_) , .getStoreByLatLong(_,_,_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var storesArr = [StoresModal]()
            for element in arr {
                let store = StoresModal.init(json: element)
                storesArr.append(store)
            }
            return storesArr as AnyObject
            
        case .getOperatingLocations :
            
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var serviceArray = [ServiceListModal]()
            for element in arr {
                let store = ServiceListModal.init(json: element)
                serviceArray.append(store)
            }
            return serviceArray as AnyObject
            
        case .getAddressesList(_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var addressArr = [MyAddressesModal]()
            for element in arr {
                let address = MyAddressesModal.init(json: element)
                addressArr.append(address)
            }
            return addressArr as AnyObject
            
           case .getStoresItem(_):
            let object = Mapper<StoreItemModal>().map(JSONObject: data)
            return object
            
        case .getConfigurations :
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var priceCalArr = [PriceCalculationModal]()
            for element in arr {
                let store = PriceCalculationModal.init(json: element)
                priceCalArr.append(store)
            }
            return priceCalArr as AnyObject
            
        case .getOffers , .getAllCoupons , .getAllCouponsByStore(_):
            let parameters = JSON(data)
            guard let arr = parameters.array else {
                return "Failure" as? AnyObject
            }
            var priceCalArr = [GetOffersModal]()
            for element in arr {
                let store = GetOffersModal.init(json: element)
                priceCalArr.append(store)
            }
            return priceCalArr as AnyObject
            
        case .saveStoreOrders(_) , .getCashFreeToken(_):
            let object = Mapper<StoreOrdersModal>().map(JSONObject: data)
            return object
       
        case .applyCoupon(_):
            let object = Mapper<CouponCodeModal>().map(JSONObject: data)
            return object
            
        default:
            return "" as? AnyObject
            
        }
    }
    
}

