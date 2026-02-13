//
//  MyAddressCell.swift
//  Dodoo
//
//  Created by Shubham Dhingra on 28/09/20.
//  Copyright © 2020 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

protocol ActionOnSelectAddressDelegate: AnyObject  {
    func actionOnSelectAddress(_ index : Int , _ actions : String?)
//   func selectAddressAct(_ selectAddress : MyAddressesModal?)
}

class MyAddressCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var lblDesc : UILabel?
    weak var delegate : ActionOnSelectAddressDelegate?
    var model : Any?{
        didSet{
            configure()
        }
    }
    var index : Int?
    
    
    func configure() {
        if let model = model as? MyAddressesModal {
            var completeTitle : String?
            
            if let title = model.title {
                completeTitle = title
            }
            if let isCurrentAddress = model.isCurrentAddress {
                if isCurrentAddress {
                    completeTitle = /completeTitle + " (Current)"
                }
            }
            lblTitle?.text = /completeTitle
            var completeAddress : String?
            
            if let doorNo = model.DoorNo {
                completeAddress = doorNo
            }
            if let address = model.address {
                completeAddress = /completeAddress + "," + address
            }
            
            if let mobile = model.Mobile {
                completeAddress = /completeAddress + "\n\n" + mobile
            }
            if let city = UDKeys.UsedCity.fetch() {
                            
                if completeAddress!.contains(city as! String) {
                            
                    self.enable(on: true)
                }
                else {
                                
                    self.isUserInteractionEnabled = false
                    self.enable(on: false)
                }
            }
            else {
                            
                let city = UDKeys.CurrentCity.fetch()!
                            
                if completeAddress!.contains(city as! String) {
                        
                    self.enable(on: true)
                }
                else {
                                
                    self.isUserInteractionEnabled = false
                    self.enable(on: false)
                }
            }
            lblDesc?.text = /completeAddress
        }
    }
    
    
    @IBAction func btnOnTapBurgerAct(_ sender : UIButton){
        self.showActionSheetWithStringButtons(buttons: /(model as? MyAddressesModal)?.isCurrentAddress ? [R.string.localize.edit() , R.string.localize.delete()] : [R.string.localize.useAsCurrent(), R.string.localize.edit() , R.string.localize.delete()]) { [weak self] (str) in
            
            guard let self = self else {
                return
            }
            
            self.delegate?.actionOnSelectAddress(/self.index , str)
        }
    }
}


extension MyAddressCell {
    func showActionSheetWithStringButtons(  buttons : [String] , success : @escaping (String) -> ()) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for button in buttons {
            let action = UIAlertAction(title: button , style: .default, handler: { (action) -> Void in
                success(button)
            })
            controller.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel) { (button) -> Void in}
        controller.addAction(cancel)
//        controller.view.tintColor = UIColor.ColorApp
        ez.topMostVC?.present(controller, animated: true) { () -> Void in
            
        }
    }
}

extension UITableViewCell {
    func enable(on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
