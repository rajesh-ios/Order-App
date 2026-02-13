
//
//  StoreViewController.swift
//  Dodoo
//
//  Created by Shubham on 25/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions
class StoreViewController: BaseViewController {
    
    @IBOutlet weak var tutorialCollection : UICollectionView?
    @IBOutlet weak var tutorialCollectionHeightConstraint : NSLayoutConstraint?
    @IBOutlet weak var txtSearch : UITextField?
    @IBOutlet weak var lblNoStores : UITextView?
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var isFirstTime : Bool = true
    var isFirstTimeTutorial : Bool = true
    var isFirstTimeStoreCollection : Bool = true
    var advertisementArr = [String]()
    var storesArr = [StoresModal]()
    var place : String? = "Anantapur"
    var selectCategoryIndex : Int? = 0
    var tutorialCollectionDataSource : CollectionViewDataSource?{
        didSet{
            tutorialCollection?.dataSource = tutorialCollectionDataSource
            tutorialCollection?.delegate = tutorialCollectionDataSource
            tutorialCollection?.reloadData()
        }
    }
    
    var categoriesArr : [OrdersModal]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        tutorialCollection?.isHidden = true
//        ez.runThisInMainThread {
//            self.advertisementArr.count == 0 ? self.getAdvertisement() : self.reloadTutCollection()
//        }
        getCategories()
        
    }
    
    
    func getCategories() {
        Utility.shared.startLoader()
        APIManager.shared.request(with: HomeEndpoint.getCategories(value: "0")) { [weak self](response) in
            self?.handle(response : response)
        }
    }
    
    func handle(response : Response){
        switch response {
        case .success(let object):
            if let arr = object as? [OrdersModal]{
                if self.categoriesArr?.count == 0  || self.categoriesArr == nil{
                    self.categoriesArr = arr
                    //                    reloadCollection()
                    self.updateSelectCategory(/self.selectCategoryIndex)
                }
            }
            if let arr = object as? [StoresModal]{
                self.storesArr = arr
                lblNoStores?.isHidden = self.storesArr.count != 0
                reloadTable()
            }
            
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
        Utility.shared.stopLoader()
    }
    
}

//Reload & Configure Categories Collection
extension StoreViewController {
    
    func configureCollectionView(){
        
        collectionDataSource = CollectionViewDataSource(items: categoriesArr, collectionView: collectionView, cellIdentifier: R.reuseIdentifier.categoriesCell.identifier, headerIdentifier: nil, cellHeight: 40, cellWidth: 136)
        
        collectionDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? CategoriesCell)?.modal = item
        }
        collectionDataSource?.aRowSelectedListener = { [weak self](indexpath, _) in
            
            guard let self = self else {
                return
            }
            self.didSelect(indexpath.row)
        }
    }
    
    func didSelect(_ index : Int){
        updateSelectCategory(index)
    }
    
    
    func updateSelectCategory(_ selectIndex : Int){
        for( index , _) in (categoriesArr ?? []).enumerated() {
            self.categoriesArr?[/index].isSelected = selectIndex == index
        }
        selectCategoryIndex = selectIndex
        DispatchQueue.main.async {
            self.reloadCollection()
            self.getStores()
        }
       
    }
    
    
    func reloadCollection() {
        if isFirstTime {
            isFirstTime = !isFirstTime
            configureCollectionView()
            
        }
        else {
            collectionDataSource?.items = categoriesArr
            collectionView.reloadData()
        }
        self.collectionView.scrollToItem(at: IndexPath(row: /selectCategoryIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

//API - Get stores List
extension StoreViewController {
    
    
    //API to get the store on the basics of category Id
    func getStores() {
        
        self.storesArr.removeAll()
        self.reloadTable()
        if /self.categoriesArr?.count != 0 {
            guard let catID = self.categoriesArr?[/selectCategoryIndex].id else {
                print("Category id is nil")
                return
            }
            Utility.shared.startLoader()
            
            if UDKeys.UsedLat.fetch() as? Double != nil {
                
                APIManager.shared.request(with: HomeEndpoint.getStoreByLatLong(userID: catID , lat : (UDKeys.UsedLat.fetch() as? Double)?.toString , long : (UDKeys.UsedLong.fetch() as? Double)?.toString)) { [weak self](response) in
                    self?.handle(response: response)
                }
            }
            else if UDKeys.CurrentLat.fetch() as? Double != nil {
                    
                    
                APIManager.shared.request(with: HomeEndpoint.getStoreByLatLong(userID: catID , lat : (UDKeys.CurrentLat.fetch() as? Double)?.toString , long : (UDKeys.CurrentLong.fetch() as? Double)?.toString)) { [weak self](response) in
                        self?.handle(response: response)
                }
            }
            else {
                    
                return
            }
            
        }
        
    }
    
    //API to get the store on the basics of searchText

    func getSearchStores(searchText : String?) {
        
        guard let searchText = searchText else {
            self.getStores()
            return
        }
        
        APIManager.shared.request(with: HomeEndpoint.searchStore(text: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),isLoader: false) { [weak self](response) in
            self?.handle(response: response)
        }
    }
}

extension StoreViewController {
    
    func configureTableView() {
        
        tableDataSource = TableViewDataSource(items: storesArr, height: 250.0, tableView: tableView, cellIdentifier: R.nib.storesCell.identifier)
        
        tableDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? StoresCell)?.modal = item
        }
        tableDataSource?.aRowSelectedListener = { [weak self] (indexpath,cell) in
            
            guard let self = self else { return  }
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
        
        txtSearch?.resignFirstResponder()
        if index < storesArr.count {
            if /self.storesArr[index].IsStoreOpen {
                guard let vc = R.storyboard.home.storeItemViewController() else {
                    return
                }
                vc.storeModal = self.storesArr[index]
                self.pushVC(vc)
            }
            else {
                Messages.shared.show(alert: .oops, message: "Currently Store is not available to take orders", type: .warning)
            }
        }
    }
}



//Reload & Configure Advertisement Collection
extension StoreViewController {
    
    func configureTutorialCollectionView(){
        
        tutorialCollectionDataSource = CollectionViewDataSource(items: advertisementArr, collectionView: tutorialCollection, cellIdentifier: R.reuseIdentifier.tutorialCell.identifier, headerIdentifier: nil, cellHeight: 200, cellWidth: 140)
        
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
            collectionDataSource?.items = advertisementArr
            collectionView.reloadData()
        }
    }
}


extension StoreViewController {
    
    func getAdvertisement() {
        
        guard let  cityCode = UDKeys.CityCode.fetch() as? String  else {
            return
        }
        APIManager.shared.request(with: LoginEndpoint.getAdvertisement(cityCode: cityCode) , isLoader: false) {[weak self](response) in
            self?.handleAdvertisement(response : response)
        }
    }
    
    func handleAdvertisement(response : Response){
        
        switch response {
        case .success(let Val):
            if let arr = Val as? [String] {
                self.advertisementArr = arr
                reloadTutCollection()
            }
            
        case .failure(_):
            break
            //            Messages.shared.show(alert: .oops, message: /error, type: .warning)
        }
    }
}


extension StoreViewController{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchStr  = ((/txtSearch?.text) as NSString).replacingCharacters(in: range, with: string.trimmingCharacters(in: .whitespaces))
        
        self.getSearchStores(searchText: searchStr.isEmpty ? nil : searchStr)
        return true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearch {
            view.endEditing(true)
            return true
        }
        return false
    }
}
