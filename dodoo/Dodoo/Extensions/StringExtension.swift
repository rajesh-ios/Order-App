//
//  StringExtension.swift
//  Dodoo
//
//  Created by Shubham on 21/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit


extension String {
    func getDateInFormat(IPFormat : String? = "yyyy-MM-dd HH:mm:ss", OPFormat : String? = "yyyy-MM-dd") -> String {
        
        var strDate                 = String()
        
        let dateFormatterGet        = DateFormatter()
        dateFormatterGet.dateFormat = IPFormat
        let serverDate = dateFormatterGet.date(from : self)
        
        if let date = serverDate {
            strDate = dateFormatterGet.string(from: date)
        }
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = OPFormat
        if !strDate.isEmpty{
            let date: Date? = dateFormatterGet.date(from: strDate)
            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    func replace(target: String, withString: String) -> String{
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
