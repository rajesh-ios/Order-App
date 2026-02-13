//
//  StoresCell.swift
//  Dodoo
//
//  Created by Shubham on 25/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Cosmos
//import EZSwiftExtensions
protocol  OrderNowDelegate {
    func orderNow(index : Int)
}
class StoresCell : TableParentCell {

    @IBOutlet weak var lblStoreName : UILabel?
    @IBOutlet weak var lblMinOrderPrice : UILabel?
    @IBOutlet weak var starView : CosmosView?
    @IBOutlet weak var imgStore : UIImageView?
    @IBOutlet weak var lblRating : UILabel?
    @IBOutlet weak var btnOrderNow : UIButton?
    @IBOutlet weak var lblDeliveryTime : UILabel?
    @IBOutlet weak var viewStoreClosed : UIView?
    @IBOutlet weak var lblStoreClosed : UILabel?
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var offerdescView: UIView!
    
    var index : Int?
    var delegate : OrderNowDelegate?
    
    var postImageURL: String? {
            didSet {
                if let url = postImageURL {
                    self.imgStore!.image = UIImage(named: "no_image_available")
                    
                    DispatchQueue.main.async {
                        
                        UIImage.loadImageWithUrlString(url, pointSize: CGSize(width: (self.imgStore?.size.width)!, height: (self.imgStore?.size.height)!)) { image in
                            
                            DispatchQueue.main.async {
                                
                                self.imgStore?.image = image
                            }
                        }
                    }
                }
                else {
                    self.imgStore!.image = nil
                }
            }
        }
    
    
    override func configure() {
        
        if let modal = modal as? StoresModal {
            lblRating?.text  = "4.0"
            starView?.rating = 4.0
            lblStoreName?.text = modal.StoreName
            if let deliveryTime = modal.DeliveryTime {
                lblDeliveryTime?.text = "Estimated : \(deliveryTime)"
            }
            
            if let minOrder = modal.MinOrder {
                lblMinOrderPrice?.text = "Min Order : \(minOrder) INR"
            }
            
            if let address = modal.address {
                
                storeAddressLabel.text = address
            }
            
            if let storeCoupon = modal.storecoupons {
                
                if storeCoupon.count > 0 {
                    
                    offerdescView.isHidden = false
                    couponView.isHidden = false
                    
                    if let description = storeCoupon[0].description {
                        
                        discountLabel.text = description
                    }
                    
                    if let offer = storeCoupon[0].couponCode {
                        
                        offerLabel.text = offer
                    }
                }
                else {
                    
                    offerdescView.isHidden = true
                    couponView.isHidden = true
                }
                
            }
            
            if let storeOpen = modal.IsStoreOpen {
                viewStoreClosed?.isHidden = (/storeOpen)
                lblStoreClosed?.isHidden = (/storeOpen)
            }
            
            
            
            if let url = modal.ImagePath {
                if url.trimmed().count != 0 {
                    //                  imgStore?.loadURL(urlString: "\(APIConstants.basePath2)\(url)", placeholder: nil, placeholderImage: UIImage(named: "no_image_available")!)
                    
                    postImageURL = "\(APIConstants.basePath2)\(url)"
                }
                else {
                    imgStore?.image = UIImage(named: "no_image_available")!
                    //                      imgStore?.loadURL(urlString: "\(APIConstants.basePath2)StoreImages/dodoo.jpg", placeholder: nil, placeholderImage: nil)
                }
            }
            //            if let star = modal.Star {
            //                lblRating?.text = star
            //            }
        }
    }
    
    
    @IBAction func btnOrderNowAct(_ sender : UIButton){
        delegate?.orderNow(index: sender.tag)
    }
    
    func downsample(data: Data,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
    
}
