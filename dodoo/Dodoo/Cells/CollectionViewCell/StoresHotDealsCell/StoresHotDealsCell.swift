//
//  StoresHotDealsCell.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 7/16/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//



import UIKit
import Cosmos

//protocol  OrderNowDelegate {
//    func orderNow(index : Int)
//}
class StoresHotDealsCell : UICollectionViewCell {
    
    @IBOutlet weak var lblStoreName : UILabel?
    @IBOutlet weak var lblMinOrderPrice : UILabel?
    @IBOutlet weak var starView : CosmosView?
    @IBOutlet weak var imgStore : UIImageView?
    @IBOutlet weak var lblRating : UILabel?
    @IBOutlet weak var btnOrderNow : UIButton?
    @IBOutlet weak var lblDeliveryTime : UILabel?
    @IBOutlet weak var lblStoreAddress: UILabel!
    var index : Int?
    var modal : Any? {
        didSet {
            configure()
        }
    }
//    var delegate : OrderNowDelegate?
    
    func configure() {
        
        if let modal = modal as? StoresModal {
            lblRating?.text  = "4.0"
//            starView?.rating = 4.0
            lblStoreName?.text = modal.StoreName
            lblStoreAddress.text = modal.address
            if let deliveryTime = modal.DeliveryTime {
                lblDeliveryTime?.text = "Estimated : \(deliveryTime)"
            }
            
            if let minOrder = modal.MinOrder {
                lblMinOrderPrice?.text = "Min Order : \(minOrder)"
            }
            
            if let url = modal.ImagePath {
                imgStore?.loadURL(urlString: "\(APIConstants.basePath2)\(url)", placeholder: nil, placeholderImage: UIImage(named: "no_image_available"))
            }
            
            //            if let star = modal.Star {
            //                lblRating?.text = star
            //            }
        }
    }
    
    
//    @IBAction func btnOrderNowAct(_ sender : UIButton){
//        delegate?.orderNow(index: sender.tag)
//    }
//
    
}
