//
//  CollectionViewDataSource.swift
//  SafeCity
//
//  Created by Aseem 13 on 29/10/15.
//  Copyright © 2015 Taran. All rights reserved.
//


import UIKit

typealias ScrollViewScrolled = (UIScrollView) -> ()
typealias WillDisplay = (_ indexPath : IndexPath) -> ()
typealias ScrollViewAnimator = (UIScrollView) -> ()
typealias CurrentIndex = (Int) -> ()



class CollectionViewDataSource: NSObject  {
    
    var items : Array<Any>?
    var cellIdentifier : String?
    var headerIdentifier : String?
    var collectionView  : UICollectionView?
    var cellHeight : CGFloat = 0.0
    var cellWidth : CGFloat = 0.0
    
    var scrollViewListener : ScrollViewScrolled?
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    var scrollViewAnimator : ScrollViewAnimator?
    var willDisplay : WillDisplay?
    var currentIndex: CurrentIndex?
    
    init (items : Array<Any>?  , collectionView : UICollectionView? , cellIdentifier : String? , headerIdentifier : String? , cellHeight : CGFloat , cellWidth : CGFloat)  {
        
        self.collectionView = collectionView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        
    }
    
    override init() {
        super.init()
    }
    
}

extension CollectionViewDataSource : UICollectionViewDelegate , UICollectionViewDataSource, UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier ,
                                                      for: indexPath) as UICollectionViewCell
        if let block = self.configureCellBlock , let item: Any = self.items?[indexPath.row]{
            block(cell , item , indexPath as IndexPath?)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let block = self.aRowSelectedListener, let item: Any = self.items?[(indexPath).row]{
            block(indexPath ,item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let block = willDisplay {
            block(indexPath)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let block = scrollViewListener {
            block(scrollView)
        }

        if let block = currentIndex {
            
            let visibleCells = collectionView!.visibleCells
            if let firstCell = visibleCells.first {
                if let indexPath = collectionView!.indexPath(for: firstCell as UICollectionViewCell) {
                    block(indexPath.row)
                }
            }
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let block = scrollViewAnimator {
            block(scrollView)
        }
    }
    
}

extension CollectionViewDataSource : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if cellIdentifier == R.reuseIdentifier.categoriesCell.identifier {
            if let item = self.items?[indexPath.row] as? OrdersModal , let title = item.title {
                let label = UILabel(frame: CGRect.zero)
                label.text = title
                label.sizeToFit()
                return CGSize(width: label.frame.width + 30 , height: cellHeight)
                
//                 return CGSize(width: widthOfString(text: title, usingFont: UIFont.systemFont(ofSize: 13.0)), height: cellHeight)
            }
            else {
                return CGSize(width: cellWidth, height: cellHeight)
           }
        }
        else {
             return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func widthOfString(text : String ,  usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = text.size(withAttributes: fontAttributes)
        return size.width
    }
    
}

