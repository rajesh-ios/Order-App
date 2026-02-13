
//
//  LoaderView.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/8/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet weak var imgView : UIImageView? {
        didSet {
            self.imgView?.layer.cornerRadius = /self.imgView?.frame.size.width / 2.0
        }
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LoaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView}

}
