//
//  HotDealsViewController.swift
//  Dodoo
//
//  Created by Shubham on 20/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

class HotDealsViewController : BaseViewController {
    
    //Outlets
    @IBOutlet weak var tutorialCollection : UICollectionView?
    @IBOutlet weak var tutorialCollectionHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    //variables
    var isFirstTimeTutorial : Bool = true
    var isFirstTimeStoreCollection : Bool = true
    var storesArr = [StoresModal]()
//    5bf038cece142a03f4572b6a
    
//    var CatID : String? = "5bf038cece142a03f4572b6a"
//    var place : String? = "Anantapur"
    var advertisementArr = [String]()
    var tutorialCollectionDataSource : CollectionViewDataSource?{
        didSet{
            tutorialCollection?.dataSource = tutorialCollectionDataSource
            tutorialCollection?.delegate = tutorialCollectionDataSource
            tutorialCollection?.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        onViewWillAppear()
    }
    
    func  onViewWillAppear() {
        advertisementArr.count != 0 ? reloadTutCollection() :  getAdvertisement()
        storesArr.count != 0 ?  reloadTable() :  getStores()
    }

}

//API - Get stores List
extension HotDealsViewController {
    
    func getStores() {
        APIManager.shared.request(with: HomeEndpoint.getStoreByLatLong(userID: CatID, lat: (UDKeys.UsedLat.fetch() as? Double)?.toString, long: (UDKeys.UsedLong.fetch() as? Double)?.toString) , isLoader : isFirstTimeStoreCollection) { [weak self](response) in
           self?.handle(response: response)
        }
    }
    
    func handle(response : Response){
        switch response {
        case .success(let object):
            if let arr = object as? [StoresModal]{
                self.storesArr = arr
                reloadTable()
            }
            
            if let arr = object as? [String] {
                self.advertisementArr = arr
                reloadTutCollection()
            }
            
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
    }
}


extension HotDealsViewController {
    
    func getAdvertisement() {
        APIManager.shared.request(with: LoginEndpoint.getAdvertisement(cityCode : self.storesArr.first?.CityCode)) {[weak self](response) in
            self?.handle(response : response)
        }
    }
    
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: storesArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.nib.storesCell.identifier)
        
        tableDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? StoresCell)?.modal = item
        }
        tableDataSource?.aRowSelectedListener = {(indexpath,cell) in
            self.didSelectStore(indexpath.row)
        }
    }
    
    func reloadTable() {
        tableView.register(R.nib.storesCell(), forCellReuseIdentifier: R.nib.storesCell.identifier)
        if isFirstTimeStoreCollection {
            self.isFirstTimeStoreCollection = false
            configureTableView()
        }
        else {
            tableDataSource?.items = self.storesArr
            tableView?.reloadData()
        }
    }
    
    
    func didSelectStore(_ index : Int){
        if index < storesArr.count {
            guard let vc = R.storyboard.home.storeItemViewController() else {
                return
            }
            vc.storeModal = self.storesArr[index]
            self.pushVC(vc)
        }
    }
}



//Reload & Configure Advertisement Collection
extension HotDealsViewController {
    
    func configureTutorialCollectionView(){
        
        tutorialCollectionDataSource = CollectionViewDataSource(items: advertisementArr, collectionView: tutorialCollection, cellIdentifier: R.reuseIdentifier.tutorialCell.identifier, headerIdentifier: nil, cellHeight: 140, cellWidth: 140)
        
        tutorialCollectionDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? TutorialCell)?.modal = item
            (cell as? TutorialCell)?.index  = indexpath?.row
        }
    }
    
    func reloadTutCollection() {
        tutorialCollectionHeightConstraint?.constant = advertisementArr.count == 0 ? 0.0 : 150.0
        if isFirstTimeTutorial {
            isFirstTimeTutorial = !isFirstTimeTutorial
            configureTutorialCollectionView()
            
        }
        else {
            tutorialCollectionDataSource?.items = advertisementArr
            tutorialCollection?.reloadData()
        }
    }
}
