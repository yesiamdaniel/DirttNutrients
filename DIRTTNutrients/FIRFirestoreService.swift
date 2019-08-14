//
//  FIRFirestoreService.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-24.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import Foundation
import Firebase

class FIRFirestoreService {
    
    //TODO: what is Creating a singleton?

    static let partRef = Firestore.firestore().collection("parts")
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    static func create(binId: [String], description: String, partClass: String, partNumber: String, quantity: Int, warehouse: String) {
        
    
        let parameters: [String : Any] = [
            "binID" : ["02-16-A", "02-04-D"],
            "description" : "AFB 101 - Trim and Lid - GNT",
            "partClass" : "Power",
            "partNumber" : "101-AFB",
            "quantity" : 48,
            "warehouse": "CGY"
            ]
        
        partRef.document(parameters["partNumber"] as! String ).setData(parameters)
    }
    
    static func fetch() {

    }
}
