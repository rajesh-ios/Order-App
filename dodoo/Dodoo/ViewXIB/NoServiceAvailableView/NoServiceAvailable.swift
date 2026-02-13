
//
//  LoaderView.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/8/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
protocol OkButtonDelegate {
    func changeLocationTapped()
    func requestDodooTapped()
}
class NoServiceAvailableView : UIView {
   
    var delegate : OkButtonDelegate?
    
    override func draw(_ rect: CGRect) {
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "NoServiceAvailable", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView}

    
    @IBAction func btnChangeLocationAct(_ sender : UIButton){
        delegate?.changeLocationTapped()
        self.removeFromSuperview()
    }
    
    @IBAction func btnrequestDodooAct(_ sender : UIButton){
        delegate?.requestDodooTapped()
        self.removeFromSuperview()
    }
}
