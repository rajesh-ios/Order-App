//
//  StoreItemViewController.swift
//  Dodoo
//
//  Created by Shubham on 02/03/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
//import EZSwiftExtensions

class StoreItemViewController : BaseViewController {
    
    
    //MARK::- Outlets
    @IBOutlet weak var imgStore : UIImageView?
    @IBOutlet weak var lblDeliveryTime : UILabel?
    @IBOutlet weak var lblStoreName : UILabel?
    @IBOutlet weak var selectCartView : UIView?
    @IBOutlet weak var lblTotalItem : UILabel?
    @IBOutlet weak var lblTotalCost : UILabel?
    @IBOutlet weak var btnCart : UIButton?
    @IBOutlet weak var lblNoStoreInf : UILabel?
    @IBOutlet weak var lblStoreNameHeading : UILabel?
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    //MARK::- Variables
    var storeModal : StoresModal?
    var itemArr : [Items]?
    var selectItemArr = [Items]()
    var categoriesWithItemArr = [ItemCategory]()
    var isFirstTime : Bool = true
    var collectionLoadIsFirstTime: Bool = true
    var totalItemSelect : Int = 0
    var totalCostSelect : Int = 0
    var coupons = [GetOffersModal]()

    
    
    var storeTableDataSource : StoreTableDataSource?{
        didSet{
            tableView?.dataSource = storeTableDataSource
            tableView?.delegate = storeTableDataSource
            tableView?.reloadData()
        }
    }
    
    var couponDataSource: CollectionViewDataSource?{
        didSet{
            couponCollectionView?.dataSource = couponDataSource
            couponCollectionView?.delegate = couponDataSource
            couponCollectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoStoreInf?.isHidden = true
        
        setupLabelTap()
        
        couponCollectionView.register(UINib(nibName: "StoreCouponCell", bundle: nil), forCellWithReuseIdentifier: "StoreCouponCell")
        
        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        updateView()
        Utility.shared.startLoader()
        getNewOffers()
        getStoreItem()
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {

        print("changeLocation tapped")
        WhatsAppManager.shared.openWhatsappStoreItem()
    }
        
        func setupLabelTap() {
            
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            self.lblNoStoreInf?.isUserInteractionEnabled = true
            self.lblNoStoreInf?.addGestureRecognizer(labelTap)
            
        }
    
    func updateView() {
        selectCartView?.isHidden = totalItemSelect == 0
        if let modal = storeModal {
            lblStoreName?.text = modal.StoreName
            lblStoreNameHeading?.text = modal.StoreName
            if let deliveryTime = modal.DeliveryTime {
                lblDeliveryTime?.text = "Estimated delivery time : \(deliveryTime)"
            }
            
            if let url = modal.ImagePath {
                if url.trimmed().count != 0 {
                  imgStore?.loadURL(urlString: "\(APIConstants.basePath2)\(url)", placeholder: nil, placeholderImage: UIImage(named: "no_image_available"))
                }
                
//                if url.trimmed().count != 0 {
////                  imgStore?.loadURL(urlString: "\(APIConstants.basePath2)\(url)", placeholder: nil, placeholderImage: UIImage(named: "no_image_available"))
////                    DispatchQueue.global().async {
//
//                        UIImage.loadImageWithUrlString("\(APIConstants.basePath2)\(url)", pointSize: CGSize(width: (self.imgStore?.size.width)!, height: (self.imgStore?.size.height)!)) { image in
//
//                            DispatchQueue.main.async {
//
//                                self.imgStore?.image = image
//                            }
//
//                        }
////                    }
                    
                else {
                    imgStore?.image = UIImage(named: "no_image_available")!
                }
            }

        }
    }
    
    
    //Buttons Action Check CartList
    @IBAction func btnViewCartAct(_ sender : UIButton){
        guard let cartVC = R.storyboard.home.cartViewController() else {
            return
        }
        cartVC.storeModal = self.storeModal
        cartVC.selectItems = self.selectItemArr
        cartVC.delegate = self
        self.pushVC(cartVC)
    }
}


//API - Get stores List
extension StoreItemViewController {
    
    func getNewOffers() {
        APIManager.shared.request(with: HomeEndpoint.getAllCouponsByStore(storeId : /self.storeModal?.id), isLoader: false) { [weak self](response) in
            self?.handleCoupons(response : response)
        }
    }
    
    func handleCoupons(response : Response){
        
        switch response {
        case .success(let obj):
            if let modal = obj as? [GetOffersModal]{
                self.coupons = modal
                
                if self.coupons.count > 0 {
                    
                    DispatchQueue.main.async {
                        
                        self.reloadCollection()
                    }
                }
                else {
                    
                    couponCollectionView.removeFromSuperview()
                }
                
            }
            
        case .failure(_):
            Utility.shared.stopLoader()
            break
        }
    }
    
    func reloadCollection() {
        
        if collectionLoadIsFirstTime {
            collectionLoadIsFirstTime = !collectionLoadIsFirstTime
            configureCouponCollection()
        }
        else {
            collectionDataSource?.items = coupons
            collectionView.reloadData()
        }
    }
    
    func getStoreItem() {
        APIManager.shared.request(with: HomeEndpoint.getStoresItem(StoreID: /self.storeModal?.id?.isEmpty ? /self.storeModal?.storeID : /self.storeModal?.id),isLoader: true) { [weak self](response) in
                self?.handle(response: response)
            }
        
    }
    
    func handle(response : Response){
        switch response {
        case .success(let obj):
            collectItembasedOnCategory(obj : obj)
            
        case .failure(let error):
            Messages.shared.show(alert: .oops, message: /error, type: .warning)
            Utility.shared.stopLoader()
        }
    }
    
    
    func collectItembasedOnCategory(obj : AnyObject?){
        getDifferentCategory(obj: obj) { (categoryArr) in
            self.categoriesWithItemArr = categoryArr
            
            if self.categoriesWithItemArr.count > 0 {
                
                ez.runThisInMainThread {
                   self.reloadTable()
                }
            }
            else {
                
                self.lblNoStoreInf?.isHidden = false
                self.lblNoStoreInf?.text = "New menu is coming soon. Still you can place order in whatsapp 9703001155"
                
                self.tableView.removeFromSuperview()
            }
            Utility.shared.stopLoader()
        }
    }
    
    func getDifferentCategory(obj : AnyObject? , completion : @escaping ([ItemCategory]) -> ()){
        if let modal = obj as? StoreItemModal {
            self.itemArr = modal.items
            let getCategories = modal.items?.map({ (items) -> String in
                return /items.Category
            })
            
            print("Categories : \(/getCategories?.count)")
            if let diffCategory = getCategories?.unique() {
                let cateArr = diffCategory.map { (category) -> ItemCategory in
                    
                    let item = self.itemArr?.filter({ (items) -> Bool in
                        return items.Category == category
                    })
                    let arr = ItemCategory.init(categoryName_: category , items_ : item)
                    return arr
                }
                completion(cateArr)
            }
            else {
                
                completion([])
            }
        }
    }
    
    
    
}



extension StoreItemViewController {
    
    func configureCouponCollection(){
        
        couponDataSource = CollectionViewDataSource(items: coupons, collectionView: couponCollectionView, cellIdentifier: "StoreCouponCell", headerIdentifier: nil, cellHeight: 60.0, cellWidth: self.couponCollectionView.bounds.width / 1.5)
        
        couponDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? StoreCouponCell)?.model = item
        }
    }
    
    func configureTableView() {
       storeTableDataSource = StoreTableDataSource(items: categoriesWithItemArr, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: R.nib.storeItemCell.identifier)
        
        storeTableDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? StoreItemCell)?.modal = item
            (cell as? StoreItemCell)?.indexPath = indexpath
        }
        
        storeTableDataSource?.aRowSelectedListener = {[weak self](indexpath,cell) in
            
            guard let self = self else { return }
            self.didSelectStore(indexpath.row)
        }
    }
    
    func reloadTable() {
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(R.nib.storeItemCell(), forCellReuseIdentifier: R.nib.storeItemCell.identifier)
//        lblNoStoreInf?.text = R.string.localize.menuNotAvailable("Available", /storeModal?.Mobile)
        if isFirstTime {
            self.isFirstTime = false
            configureTableView()
        }
        else {
            storeTableDataSource?.items = self.categoriesWithItemArr
            tableView?.reloadData()
        }
        updateCartList()
        tableViewBottomConstraint?.constant = self.totalItemSelect == 0 ? 0 : 72.0
    }
    
    
    func didSelectStore(_ index : Int){
        
        if index < categoriesWithItemArr.count {
        }
    }
}


//MARK::- Update Cart List
extension StoreItemViewController {
    
    func updateCartList() {
        totalCostSelect = 0
        totalItemSelect = 0
        selectItemArr = []
        if self.categoriesWithItemArr.count != 0 {
            for (_ , categories) in self.categoriesWithItemArr.enumerated() {
                for (_, item) in (categories.items ?? []).enumerated() {
                    if item.quantity == 0 {
                    continue
                    }
                    else {
                      totalItemSelect = totalItemSelect + item.quantity
                      totalCostSelect = totalCostSelect + (item.quantity * /item.UnitPrice?.toInt())
                      selectItemArr.append(item)
                    }
                }
            }
        }
        selectCartView?.isHidden = totalItemSelect == 0
        lblTotalCost?.isHidden =  totalItemSelect == 0
        lblTotalItem?.isHidden = totalItemSelect == 0
        lblTotalCost?.text =  "₹\(totalCostSelect)"
        lblTotalItem?.text = "\(totalItemSelect.toString) Item"
        
    }
}


extension StoreItemViewController : UpdateItemListDelegate {
    func updateItem(item: Items?) {
        guard let updateItem = item else {
            print("udpate Item Object is nil")
            return
        }
        
        if self.categoriesWithItemArr.count != 0 {
            var updationDone : Bool = true
            for (categoryIndex , categories) in self.categoriesWithItemArr.enumerated() {
                
                if updationDone {
                    reloadTable()
                    break
                }
                if categories.categoryName?.trimmed().lowercased() != updateItem.Category?.trimmed().lowercased()  {
                    
                    continue
                }
                
                //udpate item of same category if there any change
                else {
                    for (itemIndex, item) in (categories.items ?? []).enumerated() {
                        
                        if item.ItemName == updateItem.ItemName && item.DishType == updateItem.DishType && item.Category == updateItem.Category {
                             item.quantity = updateItem.quantity
                            self.categoriesWithItemArr[categoryIndex].items?[itemIndex] = item
                            updationDone = false
                            break
                        }
                    }
                }
            
            }
        }
        
        
    }
}
