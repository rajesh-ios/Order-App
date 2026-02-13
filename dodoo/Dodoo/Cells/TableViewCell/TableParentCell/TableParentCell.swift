//
//  TableParentCell.swift
//  Dodoo
//
//  Created by Shubham on 21/02/19.
//  Copyright © 2019 SHUBHAM DHINGRA. All rights reserved.
//

import UIKit

class TableParentCell: UITableViewCell {

    var modal : Any? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
