//
//  CustomTableViewCellForDetail.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-31.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class CustomTableViewCellForDetail: UITableViewCell {

    @IBOutlet weak var binIDLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    var binID: [String:Any]?
    
    func createCell() {
        if binID != nil {
            binIDLabel.textColor = .white
            binIDLabel.text = binID!["location"] as? String
            qtyLabel.textColor = .white
            qtyLabel.text = String(binID!["qty"] as! Int)
        }
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
