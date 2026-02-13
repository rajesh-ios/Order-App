//
//  ScheduleViewController.swift
//  Dodoo
//
//  Created by Shubham on 14/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation

class ScheduleViewController: BaseViewController {
    
    
    @IBOutlet weak var btnPickUpOrder : UIButton?
    @IBOutlet weak var btnSubscription : UIButton?
    @IBOutlet weak var btnOrder : UIButton?
    @IBOutlet weak var pageControl : UIPageControl?
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    
    var advertisementArr = [String]()
    var isFirstTime : Bool = true
    var timer : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(faButton)
//        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        onViewDidLoad()
    }
    
    
    func onViewDidLoad() {
       
        getAdvertisement()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        timer?.invalidate()
    }
    
    @IBAction func btnTypeAct(_ sender : UIButton){
        
        switch sender.tag {
            
        //pickup & drop
        case 0:
            
//            guard let vc = R.storyboard.home.pickUpAndDropViewController() else {
//                return
//            }
//            vc.module = .PickUpAndDrop
//            self.pushVC(vc)
            
            guard let vc = R.storyboard.home.pickUpDropViewController() else {
                return
            }
            
            self.pushVC(vc)
            
            break
            
        //order
        case 1:
            
            guard let vc = R.storyboard.home.storeViewController() else {
                return
            }
            vc.advertisementArr = advertisementArr
            self.pushVC(vc)
            break
            
            
        //Subscription
        case 2:
            
            guard let vc = R.storyboard.home.pickUpAndDropViewController() else {
                return
            }
            vc.module = .Subscription
            self.pushVC(vc)
            
            break
            
        default:
            break
        }
    }
    
    
    func getAdvertisement() {
        guard let  cityCode = UDKeys.CityCode.fetch() as? String  else {
            return
        }
        Utility.shared.startLoader()
        APIManager.shared.request(with: LoginEndpoint.getAdvertisement(cityCode: cityCode)) {[weak self](response) in
            self?.handle(response : response)
        }
    }
    
    func handle(response : Response){
        
        switch response {
        case .success(let Val):
            if let arr = Val as? [String] {
                self.advertisementArr = arr
                self.pageControl?.isHidden = arr.count == 0
                if arr.count != 0 {
                self.pageControl?.numberOfPages = arr.count
                self.pageControl?.currentPage = 0
                startTimer()
                }
                reloadCollection()
            }
           
        case .failure(let error):
            Messages.shared.show(alert: .oops, message: /error, type: .warning)
        }
        Utility.shared.stopLoader()
    }
    
}

extension ScheduleViewController {
    
    func configureCollectionView(){
        
        collectionDataSource = CollectionViewDataSource(items: advertisementArr, collectionView: collectionView, cellIdentifier: R.reuseIdentifier.tutorialCell.identifier, headerIdentifier: nil, cellHeight: self.collectionView.frame.height, cellWidth: self.collectionView.frame.width)
        
        collectionDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? TutorialCell)?.modal = item
            (cell as? TutorialCell)?.index  = indexpath?.row
        }
        
        collectionDataSource?.scrollViewListener = {[weak self](scrollView) in
            
            guard let self = self else {return}
            self.scrollViewDidScroll(scrollView)
        }
        
        collectionDataSource?.scrollViewAnimator = {[weak self](scrollView) in
            
            guard let self = self else {return}
            self.scrollViewDidScroll(scrollView)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView : UIScrollView){
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    func reloadCollection() {
        if isFirstTime {
            isFirstTime = !isFirstTime
            configureCollectionView()
           
        }
        else {
            collectionDataSource?.items = advertisementArr
            collectionView.reloadData()
        }
    }
    
}


//MARK ::- Automatically Scroll Timer
extension ScheduleViewController {
    
    func startTimer() {
        
        timer =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((/indexPath?.row)  < advertisementArr.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: /(indexPath?.row) + 1, section: 0)
                    if let indexPath1 = indexPath1 {
                        coll.scrollToItem(at: indexPath1, at: .right, animated: true)
                    }
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: 0)
                    if let indexPath1 = indexPath1 {
                    coll.scrollToItem(at: indexPath1, at: .left, animated: true)
                    }
                    pageControl?.currentPage = 0
                }
            }
        }
    }
}
