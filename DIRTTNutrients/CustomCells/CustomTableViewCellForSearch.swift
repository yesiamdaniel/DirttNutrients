//
//  CustomTableViewCell.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-23.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class CustomTableViewCellForSearch: UITableViewCell {

    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var partNumLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    var partAtCell: Part? = nil
    
    
    func styleDescriptionLabels () {
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.backgroundColor = nil
    }
    
    func styleBackgroundView (bgColor: UIColor) {
        background.layer.masksToBounds = true
        background.backgroundColor = bgColor
        background.layer.cornerRadius = 10
        background.layer.masksToBounds = true
    }
    
    func createCell() {
        if let part = partAtCell {
            descriptionLabel.text = part.description
            quantityLabel.text = String((part.binID[0]["qty"]! as? Int)!)
            binLabel.text = part.binID[0]["location"] as? String
            
            categoryLabel.text = part.category
            partNumLabel.text = part.partNumber
        } else {
            print("Error passing part into CustomTableViewCellForSearch")
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
