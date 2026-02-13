//
//  NewOffersViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/17/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class NewOffersViewController: BaseViewController {
    
    @IBOutlet weak var imgOffers : UIImageView?
    
    var getImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showImage()
    }
    
    override func btnBack(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
    func onViewDidLoad(){
        showImage()
    }
}


extension NewOffersViewController {
    
    func showImage() {
       
        if getImage != nil {
            imgOffers?.image  = getImage
            let resizeImage = UIImage().resizeImageWithAspect(image:getImage ?? UIImage(), scaledToMaxWidth: UIScreen.main.bounds.width - 32, maxHeight:  UIScreen.main.bounds.height - 32)

                imgOffers?.image = resizeImage
            }
        
        else {
            
            imgOffers?.image = UIImage(named: "no_image_available")
        }
    }
}



