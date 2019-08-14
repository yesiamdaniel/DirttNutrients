//
//  Data.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-22.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import Foundation

class Data {
    let data = [
        "hammer",
        "mallet",
        "axe",
        "saw/handsaw",
        "hacksaw",
        "level",
        "screwdriver",
        "Phillips screwdriver",
        "wrench",
        "monkey wrench/ pipe wrench",
        "chisel",
        "scraper",
        "wire stripper",
        "hand drill",
        "vise" ,
        "pliers" ,
        "toolbox" ,
        "plane" ,
        "electric drill",
        "drill bit",
        "saw" ,
        "power sander",
        "router",
        "wire",
        "nail",
        "washer",
        "nut",
        "wood screw",
        "machine screw",
        "bolt",
    ]
    
    var filteredData = [String]()
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = data.filter({( data : String) -> Bool in
            return data.lowercased().contains(searchText.lowercased())
        })
    }
        
}

struct Part {
    
    let name: String
    let description: String
    let category: Category
    let partNumber: String
    var quantityOnHand: Int
    let finish: Finish
    
    enum Finish: String {
        // TODO: figure out full names for abbreviation A and M
        case A = "A"
        case M = "M"
    }
    
    enum Category: String {
        case Aluminum = "Aluminum"
        // TODO
    }
}

