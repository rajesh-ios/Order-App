

//
//  ProfileOptionCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/22/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation

class ProfileOptionCell: UITableViewCell {
    
    @IBOutlet weak var imgItem : UIImageView?
    @IBOutlet weak var lblName : UILabel?
    @IBOutlet weak var lblWalletAmt : UILabel?
    @IBOutlet weak var imgArrow : UIImageView?
    
    var index : Int?
    var walletAmt : String?
    var model : Any? {
        didSet{
            configure()
        }
    }
    
    
    func configure() {
        if let model = model as? String, let index = index{
            lblWalletAmt?.isHidden = !(index == 2)
            lblWalletAmt?.text = R.string.localize.priceInRs(walletAmt ?? "0.0")
            lblName?.text = model
            imgItem?.loadURL(urlString: nil , placeholder: nil , placeholderImage: getImage(index : index))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func getImage(index : Int) ->  UIImage {
        
        switch index {
        case 0 :
            return R.image.wallet()!
        case 1:
            return R.image.profile()!
        case 2:
            return R.image.home()!
        case 3:
            return R.image.invite()!
        case 4:
            return R.image.support()!
        case 5:
            return R.image.feedback()!
        case 6:
            return R.image.changePassword()!
        case 7:
            return R.image.logout()!
        default:
            return R.image.invite()!
        }
    }
}
