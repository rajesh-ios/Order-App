//
//  Colors.swift
//  FCAlertView
//
//  Created by Kris Penney on 2016-08-26.
//  Copyright © 2016 Kris Penney. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  // Preset Flat Colors
  
  @nonobjc public static let flatTurquoise = UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
  @nonobjc public static let flatGreen = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
  @nonobjc public static let flatBlue = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1)
  @nonobjc public static let flatMidnight = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
  @nonobjc public static let flatPurple = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1)
  @nonobjc public static let flatOrange = UIColor(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
  @nonobjc public static let flatRed = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
  @nonobjc public static let flatSilver = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
  @nonobjc public static let flatGray = UIColor(red: 127/255, green: 140/255, blue: 141/255, alpha: 1)
  @nonobjc public static let flatAppGray = UIColor(red: 245.0, green: 245.0, blue: 245.0, alpha: 1.0)
  @nonobjc public static let successColor = UIColor(red: 0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
  @nonobjc public static let flatStepBlack = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1.0)
  @nonobjc public static let flatStepProgress = UIColor(red: 231.0/255, green: 129.0/255, blue: 121.0/255, alpha: 1.0)
  @nonobjc public static let flatTopTextColor = UIColor.black.withAlphaComponent(0.36)
    
    //Color for Store status
  @nonobjc public static let flatApproved = UIColor(red: 87.0/255, green: 178.0/255, blue: 82.0/255, alpha: 1.0)
  @nonobjc public static let flatPending = UIColor(red: 71.0/255, green: 191.0/255, blue: 225.0/255, alpha: 1.0)
  @nonobjc public static let pkgOrange = UIColor(red: 91.0/255, green: 51.0/255, blue: 47.0/255, alpha: 1.0)
  @nonobjc public static let pkgPurple = UIColor(red: 114.0/255, green: 116.0/255, blue: 149.0/255, alpha: 1.0)
  @nonobjc public static let pkgGreen = UIColor(red: 104.0/255, green: 168.0/255, blue: 173.0/255, alpha: 1.0)

}


extension UIColor {
    //static var ColorApp: UIColor  { get { return UIColor(red: 196.0/255.0, green: 20.0/255.0, blue: 28.0/255.0, alpha: 1.0) } }
    static var ColorApp: UIColor  { get { return UIColor(red: 192.0/255.0, green: 207.0/255.0, blue: 44.0/255.0, alpha: 1.0) } }
    
    static var ColorGrey: UIColor { get { return UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 90.0/255.0, alpha: 1.0) } }
    
    static var ColorDarkGrey: UIColor { get { return UIColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 1.0) } }
    
    static var ColorOrange: UIColor{ get { return UIColor(red: 0.96, green: 0.65, blue: 0.14, alpha: 1.0) } }
    
    static var ColorGreen: UIColor{ get { return UIColor(red: 0.49, green: 0.83, blue: 0.13, alpha: 1.0) } }
    
    static var ColorShadeBlack: UIColor{ get { return UIColor(red: 90.0, green: 90.0, blue: 91.0, alpha: 1.0) } }
    
    static var ColorBlackForOrderStatus : UIColor{ get { return UIColor(red: 60.0, green: 60.0, blue: 60.0, alpha: 1.0) } }
    
}
