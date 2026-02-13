//
//  UIImageViewExtension.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 1/22/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadURL(urlString:String?, placeholder : String?, placeholderImage : UIImage?){
        
        let cache = ImageCache.default
        let cacheKey = "DodooCache"
//        _ = cache.isImageCached(forKey: cacheKey)
        
        // To know where the cached image is:
//        _ = cache.imageCachedType(forKey: cacheKey)
        
        let imageUrl = URL(string: addPercentEncoding(url: /urlString))
        let plaecholderUrl = (placeholder != nil) ? URL(string: /placeholder) : imageUrl
        
        self.kf.setImage(with: plaecholderUrl, placeholder: placeholderImage, options: [], progressBlock: nil) { (image, _, _, _) in
            cache.removeImage(forKey: cacheKey)
            guard let _ = image else { return }
            self.kf.indicatorType = .activity
            self.kf.setImage(with: imageUrl, placeholder: image, options: [], progressBlock: nil) { (image, _, _, _) in
                
                guard let _ = image else { return }
                self.image = image
            }
        }
    }
    
    func addPercentEncoding(url : String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
    }
}

extension UIImage {
    
    static func loadImageUsingCacheWithUrlString(_ urlString: String, completion: @escaping (UIImage) -> Void) {
            if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
                completion(cachedImage)
            }

            //No cache, so create new one and set image
            let url = URL(string: urlString)
        
        if let url = url {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }

                    DispatchQueue.main.async(execute: {
                        if let downloadedImage = UIImage(data: data!) {
                            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                            completion(downloadedImage)
                        }
                    })

                }).resume()
        }
        
        
    }
    
    static func loadImageWithUrlString(_ urlString: String, pointSize: CGSize, scale: CGFloat = UIScreen.main.scale, completion: @escaping (UIImage) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            completion(cachedImage)
        }
        
        //No cache, so create new one and set image
        let url = URL(string: urlString)
        
        if let url = url {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let data = data {
                    
                    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary

                    guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
                        return
                    }
                    
                    // Calculate the desired dimension
                    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
                    
                    // Perform downsampling
                    let downsampleOptions = [
                        kCGImageSourceCreateThumbnailFromImageAlways: true,
                        kCGImageSourceShouldCacheImmediately: true,
                        kCGImageSourceCreateThumbnailWithTransform: true,
                        kCGImageSourceThumbnailMaxPixelSize: CGFloat(maxDimensionInPixels)
                    ] as CFDictionary
                    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
                        return
                    }
                    
                    // Return the downsampled image as UIImage
//                    return UIImage(cgImage: downsampledImage)
                    imageCache.setObject(UIImage(cgImage: downsampledImage), forKey: urlString as NSString)
                    completion(UIImage(cgImage: downsampledImage))
                }
            }).resume()
        }
        
    }
}
