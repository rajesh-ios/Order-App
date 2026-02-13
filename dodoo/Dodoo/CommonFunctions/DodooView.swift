//
//  DodooView.swift
//  Dodoo
//
//  Created by Apple on 05/07/21.
//  Copyright © 2021 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

@IBDesignable
class DodooView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    @IBInspectable var borderColor : UIColor = UIColor.lightGray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth : CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowColor : UIColor = UIColor.lightGray {
        didSet {
            update()
        }
    }

    @IBInspectable var shadowRadius : CGFloat = 0.5 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var shadowOffSet : CGSize = CGSize(width: 0, height: 1) {
        didSet {
            update()
        }
    }
    
    
    @IBInspectable var shadowOpacity : CGFloat = 1.0 {
        didSet {
            update()
        }
    }
    
    
    

    @IBInspectable var cornerRadius : CGFloat = 24.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    func update() {
        self.layer.shadowOffset = shadowOffSet
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = borderColor.cgColor
    }
    
}
