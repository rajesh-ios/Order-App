//
//  TutorialViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 12/21/18.
//  Copyright © 2018 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

class TutorialViewController: BaseViewController {

    @IBOutlet var pageControlView : [UIView]!
    @IBOutlet weak var btnNext : UIButton?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    @IBAction func btnNextAct(_ sender : UIButton){
        guard let vc = R.storyboard.main.loginViewController() else {return}
        self.pushVC(vc)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillApppear()
    }
    
    func onViewWillApppear() {
        if let modal = UDKeys.UserDTL.fetch() as? UserDetails {
            if modal.name != nil {
                guard let tabBarVc = R.storyboard.main.tabBarController() else {return}
                tabBarVc.selectedIndex = 0
                self.navigationController?.pushViewController(tabBarVc, animated: false)
            }
        }
    }
}



extension TutorialViewController {
    func configureCollectionView(){
        
        collectionDataSource = CollectionViewDataSource(items: ["","",""], collectionView: collectionView, cellIdentifier: R.reuseIdentifier.tutorialCell.identifier, headerIdentifier: nil, cellHeight: self.collectionView.frame.height, cellWidth: UIScreen.main.bounds.width)
        
        collectionDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? TutorialCell)?.index  = indexpath?.row
        }
        
        collectionDataSource?.currentIndex = {[weak self](row) in
            
            guard let self = self else { return }
            self.willDisplay(row)
        }
        
    }
    
    
    func willDisplay(_ index : Int?){
        if let index = index  {
            updatePageControl(currrentIndex:  index)
            btnNext?.setTitle(index == 2 ? R.string.localize.next() : R.string.localize.skip(), for: .normal)
        }
    }
    
    func updatePageControl(currrentIndex : Int){
       
        for (_, pgView) in pageControlView.enumerated() {
            pgView.backgroundColor = currrentIndex == pgView.tag ? UIColor.black : UIColor.init(hexString: "#acacac")
            
        }
    }
    
}
