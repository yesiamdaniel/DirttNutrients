//
//  bar.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-28.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class bar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        print("override")
        setShowsCancelButton(false, animated: false)
        
    }
}
