//
//  HomeViewController.swift
//  Dodoo
//
//  Created by SHUBHAM DHINGRA on 3/11/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

let CatID = "5bf038cece142a03f4572b6a"
let kHomeServices = "Home Services"
import UIKit
import CoreLocation

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var quickOrderCollection : UICollectionView?
    @IBOutlet weak var hotDealsCollection : UICollectionView?
    @IBOutlet weak var lblCurrentLocation : UILabel?
    @IBOutlet weak var deliveryTo: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pickUp_Drop: UIView!
    @IBOutlet weak var orderWhat: UIView!
    @IBOutlet weak var homeServices: UIView!
    @IBOutlet weak var scheduleOrder: UIView!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    var storesArr = [StoresModal]()
    
    var isFirstTime : Bool = true
    var categoriesArr : [OrdersModal]?
    var isFirstTimeOuickOrder : Bool = true
    var isFirstTimeHotDeals : Bool = true
    var isFirstTimeHotDealsCollection : Bool = true
    var advertisementArr = [String]()
    var isCurrentLocationEnabled : Bool = false
    var timer : Timer?
    var locationChange: Bool = false
    
    
    var quickOrderDataSource: CollectionViewDataSource?{
        didSet{
            quickOrderCollection?.dataSource = quickOrderDataSource
            quickOrderCollection?.delegate = quickOrderDataSource
            quickOrderCollection?.reloadData()
        }
    }
    
    var hotDealsDataSource : CollectionViewDataSource?{
        didSet{
            hotDealsCollection?.dataSource = hotDealsDataSource
            hotDealsCollection?.delegate = hotDealsDataSource
            hotDealsCollection?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(faButton)
        customTapGesture()
        
//        headerHeight.constant = UIDevice.current.hasNotch ? 100.0 : 80.0
        
        let width = ((quickOrderCollection?.frame.width)! - 70) / 3
        let layout = quickOrderCollection?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 110)
        
        let width1 = ((collectionView?.frame.width)! - 70) / 1
        let layout1 = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout1.itemSize = CGSize(width: width1, height: 110)
        
        StoreReviewHelper.checkAndAskForReview()
        
        DispatchQueue.main.async {
            
            LocationManager.shared.updateUserLocation()
            
            LocationManager.shared.fetchLocationWithCompletionHandler { [weak self](lat, long, city) in
                
                guard let self = self else {return}
                
                if let lat = lat, let long = long, let city = city {
                    
                    UDKeys.CurrentLat.save(lat)
                    UDKeys.CurrentLong.save(long)
                    UDKeys.CurrentCity.save(city)
                    UDKeys.CityCode.remove()
                    UDKeys.UsedLat.remove()
                    UDKeys.UsedLong.remove()
                    UDKeys.UsedCity.remove()
                    
                    self.lblCurrentLocation?.text = city
                    self.getServicesList(lat: lat, long: long)
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        onViewWillAppear()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    func onViewWillAppear() {
        
        if self.categoriesArr?.count == 0 ||  self.categoriesArr == nil {
            self.getCategories()
        }
        else {
            self.reloadQuickOrderCollection()
        }
    }
    
    
    func customTapGesture() {
        
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.changeLocationTapped))
        
        let labelTap1 = UITapGestureRecognizer(target: self, action: #selector(self.changeLocationTapped))
        
        self.deliveryTo.isUserInteractionEnabled = true
        self.deliveryTo.addGestureRecognizer(labelTap)
        self.lblCurrentLocation?.isUserInteractionEnabled = true
        self.lblCurrentLocation?.addGestureRecognizer(labelTap1)
        
        let pickupView = UITapGestureRecognizer(target: self, action: #selector(self.btnTypeAct(_:)))
        pickupView.view?.tag = 0
        
        self.pickUp_Drop.addGestureRecognizer(pickupView)
        
        let orderWhatView = UITapGestureRecognizer(target: self, action: #selector(self.btnTypeAct(_:)))
        orderWhatView.view?.tag = 1
        
        self.orderWhat.addGestureRecognizer(orderWhatView)
        
        let homeServiceView = UITapGestureRecognizer(target: self, action: #selector(self.btnTypeAct(_:)))
        homeServiceView.view?.tag = 2
        
        self.homeServices.addGestureRecognizer(homeServiceView)
        
        let scheduleView = UITapGestureRecognizer(target: self, action: #selector(self.btnTypeAct(_:)))
        scheduleView.view?.tag = 3
        
        self.scheduleOrder.addGestureRecognizer(scheduleView)
    }
    
    @IBAction func btnViewAllAct(_ sender : UIButton){
        guard let vc = R.storyboard.main.hotDealsViewController() else {
            return
        }
        vc.advertisementArr = advertisementArr
        vc.storesArr = storesArr
        self.pushVC(vc)
    }
    
    @IBAction func btnEditCurrentLocationAct(_ sender : UIButton) {
        changeCurrentLocation()
    }
    
    @IBAction func btnSearchAct(_ sender : UIButton){
        guard let vc = R.storyboard.home.storeViewController() else {
            return
        }
        vc.selectCategoryIndex = 0
        self.pushVC(vc)
    }
    
    @objc func changeCurrentLocation() {
        guard let vc = R.storyboard.main.currentLocationViewController() else {
            return
        }
        vc.locationChangeDelegate = self
        self.navigationController?.presentVC(vc)
    }
}


//API Service to get the advertisement

extension HomeViewController {
    
    // done
    func getAdvertisement() {
       
        if let cityCode = UDKeys.CityCode.fetch() {
                
            APIManager.shared.request(with: LoginEndpoint.getAdvertisement(cityCode: cityCode as? String)) {[weak self](response) in
                guard let self = self else {return}
                self.handle(response : response)
            }
        }
        
    }
    
    // done
    func handle(response : Response){
        
        switch response {
        case .success(let Val):
            if let arr = Val as? [String] {
                self.advertisementArr = arr
                
                if arr.count != 0 {
                    self.pageControl.isHidden = false
                    self.pageControl?.numberOfPages = arr.count
                    self.pageControl?.currentPage = 0
                    timer?.invalidate()
                    DispatchQueue.main.async {
                        
                        self.reloadCollection()
                    }
                    
                    startTimer()
                }
                else {
                    
                    self.pageControl?.isHidden = true
                }
                
            }
            
        case .failure(let error):
            Messages.shared.show(alert: .oops, message: /error, type: .warning)
        }
    }
    
}


//API to get the Quick Order Categories
extension HomeViewController {
    
    // done
    func getCategories() {
        APIManager.shared.request(with: HomeEndpoint.getCategories(value: "0"), isLoader : false) { [weak self](response) in
            guard let self = self else {return}
            self.handleAdv(response : response)
        }
    }
    
    // done
    func handleAdv(response : Response){
        switch response {
        case .success(let object):
            if let arr = object as? [OrdersModal]{
                self.categoriesArr = arr
                DispatchQueue.main.async {
                    self.reloadQuickOrderCollection()
                }
            }
            
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
    }
}


//MARK::- Code of New Delivery Assitant

extension HomeViewController {
    @objc func btnTypeAct(_ sender: UITapGestureRecognizer){
        
        switch sender.view?.tag {
        
        //pickup & drop
        case 0:
            
//            guard let vc = R.storyboard.home.pickUpAndDropViewController() else {
//                return
//            }
//            vc.module = .PickUpAndDrop
            
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
            
        //Home Services
        case 2:
            
            var homeServiceIndex = -1
            for (index , categories) in (self.categoriesArr ?? []).enumerated() {
                if categories.title == kHomeServices {
                    homeServiceIndex = index
                    break
                }
            }
            
            if homeServiceIndex != -1 && homeServiceIndex < /self.categoriesArr?.count{
                self.didSelect(IndexPath(row: homeServiceIndex, section: 0))
            }
        
        //Subscription
        case 3:
            
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
}



// MARK --------: Code of Advertisement Cell Collection :---------
extension HomeViewController {
    
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
        //self.storesArr.count == 0 ? self.getServicesList() : reloadHotDealsCollection()
    }
    
}





// MARK --------: Code of Quick Order Collection :---------
extension HomeViewController {
    
    func configureQuickOrderCollection(){
        
        quickOrderDataSource = CollectionViewDataSource(items: categoriesArr, collectionView: quickOrderCollection, cellIdentifier: R.reuseIdentifier.quickMenuCell.identifier, headerIdentifier: nil, cellHeight: 90.0, cellWidth: 105.0)
        
        quickOrderDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? QuickMenuCell)?.model = item
        }
        
        quickOrderDataSource?.aRowSelectedListener = {[weak self](indexpath, _) in
            
            guard let self = self else {return}
            self.didSelect(indexpath)
        }
    }
    
    func reloadQuickOrderCollection() {
        if isFirstTimeOuickOrder {
            isFirstTimeOuickOrder = !isFirstTimeOuickOrder
            configureQuickOrderCollection()
            
        }
        else {
            quickOrderDataSource?.items = self.categoriesArr
            quickOrderCollection?.reloadData()
        }
    }
    
    func didSelect(_ indexPath : IndexPath){
        let index = indexPath.row
        if index < /self.categoriesArr?.count {
            guard let vc = R.storyboard.home.storeViewController() else {
                return
            }
            vc.selectCategoryIndex = index
            self.pushVC(vc)
        }
    }
}

// MARK --------: Code of Hot deals Collection :---------
extension HomeViewController {
    
    // done
    func getServicesList(lat: Double, long: Double) {
        
        if locationChange {
            Utility.shared.startLoader()
        }
        
        APIManager.shared.request(with: HomeEndpoint.getOperatingLocations(lat: lat, long: long), isLoader: false) { [weak self](response) in
            
            guard let self = self else {return}
            self.handleService(response: response)
        }
    }
    
    // done
    func handleService(response: Response) {
        
        switch response {
        case .success(let object):
            if let serviceList = object as? [ServiceListModal]{
                
                if serviceList.count > 0 {
                    
                    if let cityCode = serviceList[0].cityCode {
                        
                        UDKeys.CityCode.save(cityCode)
                        getAdvertisement()
                        getHotDeals()
                    }
                    
                }
                else {
                    
                    UDKeys.CityCode.remove()
                    let noServiceView = NoServiceAvailableView.instanceFromNib()
                    if let frame = UIApplication.shared.keyWindow?.frame {
                        noServiceView.frame = frame
                    }
                    (noServiceView as? NoServiceAvailableView)?.delegate = self
                    UIApplication.shared.keyWindow?.addSubview(noServiceView)

                }
                
            }
            
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
        
        if locationChange {
            
            Utility.shared.stopLoader()
        }
    }
    
    // done
    func getHotDeals() {
        let lat = UDKeys.UsedLat.fetch() != nil ? UDKeys.UsedLat.fetch() : UDKeys.CurrentLat.fetch()
        let long = UDKeys.UsedLong.fetch() != nil ? UDKeys.UsedLong.fetch() : UDKeys.CurrentLong.fetch()
        
        APIManager.shared.request(with: HomeEndpoint.getStoreByLatLong(userID: CatID, lat: (lat as? Double)?.toString, long: (long as? Double)?.toString) , isLoader : false) { [weak self](response) in
            guard let self = self else {return}
            self.handleHotDeals(response: response)
        }
    }
    
    // done
    func handleHotDeals(response : Response){
        switch response {
        case .success(let object):
            if let arr = object as? [StoresModal]{
                self.storesArr = arr
                reloadHotDealsCollection()
            }
            
        case .failure(_):
            Messages.shared.show(alert: .oops, message: R.string.localize.somethingWentWrong(), type: .warning)
        }
    }
    
    
    
    func configureHotDealsCollection(){
        
        hotDealsDataSource = CollectionViewDataSource(items: storesArr, collectionView: hotDealsCollection, cellIdentifier: R.reuseIdentifier.storesHotDealsCell.identifier, headerIdentifier: nil, cellHeight: 90.0, cellWidth: 280.0)
        
        hotDealsDataSource?.configureCellBlock = {(cell, item, indexpath) in
            (cell as? StoresHotDealsCell)?.modal = item
        }
        
        hotDealsDataSource?.aRowSelectedListener = {[weak self](indexpath, _) in
            
            guard let self = self else {return}
            self.didSelectHotDeals(indexpath)
        }
    }
    
    
    func didSelectHotDeals(_ indexPath : IndexPath) {
        let index = indexPath.row
        if index < storesArr.count {
            guard let vc = R.storyboard.home.storeItemViewController() else {
                return
            }
            vc.storeModal = self.storesArr[index]
            self.pushVC(vc)
        }
    }
    
    func reloadHotDealsCollection() {
        if isFirstTimeHotDealsCollection {
            isFirstTimeHotDealsCollection = !isFirstTimeHotDealsCollection
            configureHotDealsCollection()
            
        }
        else {
            hotDealsDataSource?.items = self.storesArr
            hotDealsCollection?.reloadData()
        }
    }
}


//MARK::- Chat with Dodoo
extension HomeViewController {
    
    @IBAction func btnChatWithDodoo(_ sender : UIButton){
        WhatsAppManager.shared.openWhatsapp()
    }
}




extension HomeViewController : OkButtonDelegate {
    @objc func changeLocationTapped() {
        print("changeLocation tapped")
        changeCurrentLocation()
    }
    
    func requestDodooTapped() {
        guard let vc = R.storyboard.main.supportFeedbackViewController() else {
            return
        }
        vc.module = .Support
        self.pushVC(vc)
    }
}

extension HomeViewController : LocationChangeDelegate {
    
    func locationChanged() {
        
        UDKeys.CityCode.remove()
        locationChange = true
        if let lat = UDKeys.UsedLat.fetch(), let long = UDKeys.UsedLong.fetch() {
            
            lblCurrentLocation?.text = UDKeys.UsedCity.fetch() as? String
            self.getServicesList(lat: lat as! Double, long: long as! Double)
        }
        else {
            
            if let lat = UDKeys.CurrentLat.fetch(), let long = UDKeys.CurrentLong.fetch() {
                
                lblCurrentLocation?.text = UDKeys.CurrentCity.fetch() as? String
                self.getServicesList(lat: lat as! Double, long: long as! Double)
            }
        }
        
        
    }
}

extension HomeViewController {
    
    func startTimer() {
        
        timer =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((/indexPath?.row)  < advertisementArr.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: /(indexPath?.row) + 1, section: 0)
                    if let indexPath1 = indexPath1 {
                        coll.isPagingEnabled = false
                        coll.scrollToItem(at: indexPath1, at: .right, animated: true)
                        coll.isPagingEnabled = true
                    }
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: 0)
                    if let indexPath1 = indexPath1 {
                        coll.isPagingEnabled = false
                    coll.scrollToItem(at: indexPath1, at: .left, animated: true)
                        coll.isPagingEnabled = true
                    }
                    pageControl?.currentPage = 0
                }
            }
        }
    }
}
