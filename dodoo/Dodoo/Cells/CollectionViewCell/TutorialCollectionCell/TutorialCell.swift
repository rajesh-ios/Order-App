
//
//  TutorialCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/23/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {
    
    @IBOutlet weak var lblHeading : UILabel?
    @IBOutlet weak var lbldesc : UILabel?
    @IBOutlet weak var imgLogo : UIImageView?
    
    
    var index : Int? {
        didSet {
            configure()
        }
    }
    
    var modal : Any? {
        didSet {
            configure()
        }
    }
    
    
    func configure() {
        if let index = index {
            switch index {
            case 0:
              lblHeading?.text = R.string.localize.schduleAnOrder()
            lbldesc?.text  = R.string.localize.schdeduleDesc()
            case 1:
                lblHeading?.text = R.string.localize.addAnSubscription()
                lbldesc?.text  = R.string.localize.addAnSubscriptionDesc()
            case 2:
                lblHeading?.text = R.string.localize.itemPickAndDrop()
                lbldesc?.text  = R.string.localize.itemPickAndDropDesc()
                
            default:
                break
            }
        }
        
        if let modal = modal as? String {
            imgLogo?.loadURL(urlString: "\(APIConstants.basePath2)\(modal)", placeholder: nil, placeholderImage: nil)
            imgLogo?.contentMode = .scaleAspectFit
            imgLogo?.clipsToBounds = true
        }
    }
}
