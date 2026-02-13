

//
//  WeeklyPlanDataSource.swift
//  PalmBoard
//
//  Created by Shubham on 24/11/18.
//  Copyright © 2018 Franciscan. All rights reserved.
//

import Foundation

import UIKit
//import EZSwiftExtensions

class StoreTableDataSource   : NSObject  {
    
    var items : Array<Any>?
    var cellIdentifier : String?
    var tableView  : UITableView?
    var tableViewRowHeight : CGFloat = 0.0
    
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var viewforHeaderInSection : ViewForHeaderInSection?
    var scrollViewListener : ScrollViewScrolled?
    var headerHeight : CGFloat? = 70.0
    var sectionArr = [Int]()
    
    
    init (items : Array<Any>? , height : CGFloat , tableView : UITableView? , cellIdentifier : String?) {
        
        self.tableView = tableView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.tableViewRowHeight = height
    }
    
    override init() {
        super.init()
    }
}

extension StoreTableDataSource : UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let identifier = cellIdentifier  else {
            fatalError("Cell identifier not provided")
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if let block = self.configureCellBlock , let item: Any = (self.items?[indexPath.section] as? ItemCategory)?.items?[indexPath.row]{
            block(cell , item , indexPath as IndexPath?)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.aRowSelectedListener, case let cell as Any = tableView.cellForRow(at: indexPath){
            block(indexPath , cell)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sectionArr.contains(section){
            if let category = self.items?[section] as? ItemCategory {
                return /category.items?.count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return /items?.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let storeCategorySectionHeader =  StoreItemSectionHeader.instanceFromNib() as? StoreItemSectionHeader else {
            return UIView()
        }
        
        storeCategorySectionHeader.lblItemCaetgory?.text = (self.items?[section] as? ItemCategory)?.categoryName
        storeCategorySectionHeader.btnCategory?.setImage(UIImage(named : sectionArr.contains(section) ? "up_arrow" : "down_arrow"), for: .normal)
        storeCategorySectionHeader.tag = section
        storeCategorySectionHeader.addTapGesture(target: self, action:  #selector(self.openCloseHeader(_:)))
        return storeCategorySectionHeader
    }
    
    @objc func openCloseHeader(_ sender : UITapGestureRecognizer){
        
        guard let tag = sender.view?.tag else {return}
        if sectionArr.contains(tag) {
            if let arrIndex = sectionArr.indexes(of: tag).first {
                sectionArr.remove(at: arrIndex)
            }
        }
        else {
            sectionArr.append(tag)
        }
        tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight ?? 0.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let block = scrollViewListener {
            block(scrollView)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if let block = scrollViewBeginDeaccerlate {
//            block(scrollView)
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if let block = scrollViewEndDeaccerlate {
//            block(scrollView)
//        }
    }
}

