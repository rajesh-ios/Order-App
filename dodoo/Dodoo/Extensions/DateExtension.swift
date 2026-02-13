

//
//  DateExtension.swift
//  Dodoo
//
//  Created by Shubham on 20/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation

extension Date {
    public func dateConvert(time : Date , format : String? = "h:mm a") -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.string(from: time)
        return date
    }
}
