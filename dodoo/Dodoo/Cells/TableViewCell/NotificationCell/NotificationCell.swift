//
//  NotificationCell.swift
//  Dodoo
//
//  Created by Shubham on 21/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit
import Foundation

class NotificationCell : TableParentCell {

    @IBOutlet weak var lblMonth : UILabel?
    @IBOutlet weak var lblDate : UILabel?
    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var linearView : UIView?
    @IBOutlet weak var containerView : UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func configure() {
        if let modal = modal as? NotificationModal {
            lblTitle?.text = modal.Message
            lblDate?.text = modal.CreatedOn?.getDateInFormat(IPFormat: DateFormat.IPFormat.id, OPFormat: DateFormat.Date.id)
             lblMonth?.text = modal.CreatedOn?.getDateInFormat(IPFormat: DateFormat.IPFormat.id, OPFormat: DateFormat.Month.id)
         }
    }
}

