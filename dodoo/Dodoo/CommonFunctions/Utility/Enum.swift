
//
//  Enum.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/6/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit


enum Module : String{
    
    case ChangePassword = "Change Password"
    case ForgotPassword = "Forgot Password"
    case NewPassword = "New Password"
    case Support = "Support"
    case Feedback = "Feedback"
    case Order = "Order"
    case PickUpAndDrop = "Pickup & Drop"
    case Subscription = "Add a Subscription"
    
    var id : String {
        return self.rawValue
    }
}




enum AddressType : String {
    
    case pick = "Pickup"
    case drop = "drop"
    
    
    func getHeaderPlacholder() -> String {
        return "Add \(self.rawValue) Details"
    }
    
    func getDoorNoPlacholder() -> String {
        return "\(self.rawValue) door Number"
    }
    
    
    func getLandmarkPlaceholder() -> String {
        return "Type nearest \(self.rawValue) Landmark or area"
    }

}
enum DateFormat : String {
    case date1 = "yyyy-MM-dd"
    case date2 = "h:mm a"
    case Month = "MMM"
    case Date = "dd"
    case IPFormat = "yyyy-MM-dd HH:mm:ss"
    
    var id : String {
        return self.rawValue
    }
}


enum Arrays : Int{
    
    case ProfileOptions

    
    func get() -> [Any] {
        switch self {
            
        case .ProfileOptions :
        
            return [R.string.localize.accountDetails() ,R.string.localize.myaddress() ,R.string.localize.wallet() ,R.string.localize.inviteFriends() , R.string.localize.support() , R.string.localize.feedback() , R.string.localize.changePassword() , R.string.localize.logout()]
        }
        return []
    }
}



enum Actions {
    case Add
    case Edit
    case UseAsCurrent
    case Delete
    case View
}




