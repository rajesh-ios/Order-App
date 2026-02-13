//
//  APIConstants.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Shubham Dhingra All rights reserved.
//


import Foundation

internal struct APIConstants {
    
   // static let basePath = "http://192.168.102.89:8001/"
    
    //New live server
//    static let basePath = "http://3.129.128.96:1234/MyService.svc/"
//    static let basePath2 = "http://3.129.128.96:1234/"
    static let basePath = "https://www.dodoo.in:5678/MyService.svc/"
    static let basePath2 = "https://www.dodoo.in:5678/"
    //live server
//   static let basePath = "http://18.217.195.26:1234/MyService.svc/"
//   static let basePath2 = "http://18.217.195.26:1234/"
   static let whatsAppBusinessAcccountNo = "919703001155"
    
    //testing server
//    static let basePath = "http://18.217.195.26:5678/MyService.svc/"
//    static let basePath2 = "http://18.217.195.26:5678/"
    
    static let dodooAppLink = "https://itunes.apple.com/us/app/dodoo-anything-for-you/id1456011773?ls=1&mt=8"
    static let dodooAppPlaystorelink = "https://play.google.com/store/apps/details?id=com.moyo.dodoo&hl="
    //DEV or TEST KEY
//    static let RAZORPAY_DEV_KEY = "rzp_test_YJsk6kxWgDHV7S"
    
    //LIVE KEY
    static let RAZORPAY_DEV_KEY = "rzp_live_jx57kWxibOUSx0"
    
//    static let RAZORPAY_DEV_KEY = "rzp_live_wdCpLshfmJAZQ5" //This key changed on 5th Dec shared by pradeep over email
    static let status = "Status"
    static let message = "message"
    
    static let language = "language"
    static let login = "vendor/login"
    static let register = "RegisterUserInfo"
    static let forgotPassword = "ForgotPassword/"
    static let authentication = "Authentication"
    static let registerSupport = "RegisterSupport"
    static let registerFeedback = "RegisterFeedback"
    static let changePassword = "ChangePassword/"
    static let getAllTypeOrders = "GetAllTypeOrdersByUser/"
    static let orderDetails = "GetStoreOrdersByOrderID/"
    static let getAdvertisement = "GetAdvertisementsByCity/"
    static let saveSubscription = "SaveSubscription"
    static let savePickUpAndDrop = "SavePickupDrop"
    static let getPickUpAndDrop = "GetPickDropByOrderID/"
    static let getNotification = "GetNotificationInfo/"
    static let getCategories = "GetCategories/"
    static let getStores = "GetStores/"
    static let getStoreItem = "GetStoreItems/"
    static let apiLatestVersion = "GetLatestIOSAppVersion"
    static let saveStoreOrders = "SaveStoreOrders"
    static let getConfigurationsByCity = "GetConfigurationsByCity/"
    static let applyCoupon = "ValidateCoupon/"
    static let updateOrderStatus = "UpdateOrderStatus/"
    static let getOffers = "GetOffers"
    static let getWalletInfo = "GetWalletInfo/"
    static let validateUser = "validateUser"
    static let validateMobileNo = "ValidateSignup"
    static let getAllCouponsByCity = "GetAllCouponsByCity/"
    static let getAllCouponsByStore = "GetAllCouponsByStore/"
    static let orderPaymentInfo = "OrderPaymentInfo"
    static let searchStore = "SearchStoreItemsByCity/"
    static let getStoresByLatLong = "GetStoresByLongLat/"
    static let GetOperatingLocationsByLongLat = "GetOperatingLocationsByLongLat/"
    static let ratingToOrder = "RatetheOrder"
    static let GetSubscriptionByOrderID = "GetSubscriptionByOrderID/"

    
    //Address
    static let getUsersAddress = "GetUserAddress/"
    static let addorUpdatenewAddress = "AddNewUserAddress"
    static let deleteAddress = "DeleteUserAddress"
    
    //cashfree
    static let getCashFreeToken = "CashFreeGetToken"
    static let getCashFreeTokenForSandbox = "CashFreeGetToken_Sandbox"

}

enum Keys : String{
    
    
    //create Store
    case id
    case name
    case email
    case password
    case Address
    case reg_id
    case Details
    case Authentication
    case mobno
    case userid
    case Pasword
    
}


enum Validate : String {
    
    case none
    case success = "1"
    case failure = "0"
    case invalidAccessToken = "401"
    case adminBlocked = "403"
    
    func map(response message : String?) -> String? {
        
        switch self {
        case .success:
            return message
        case .failure :
            return message
        case .invalidAccessToken :
            return message
        case .adminBlocked:
            return message
        default:
            return nil
        }
        
    }
}

enum Response {
    case success(AnyObject?)
    case failure(String?)
}



typealias OptionalDictionary = [String : Any]?

struct Parameters {
    
    static let register : [Keys] = [.id , .name , .email ,.mobno , .password , .Address , .reg_id]
    static let details : [Keys] = [.Details]
    static let Authentication : [Keys] = [.Authentication]

}





