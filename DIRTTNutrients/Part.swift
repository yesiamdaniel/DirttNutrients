//
//  Part.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-25.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol DocumentSerializeable {
    init?(docID: String?, dictionary: [String : Any])
}

struct Part {
// On initialization of app all part data is stored here when loadPartData is called
    static var allParts = [Part]()
    
// Stores parts that match current filter
    static var partFilter = [Part]()

// This reference allows for use in static methods
    static let dbs = Firestore.firestore()
    
// This reference allows for use in Part instances
    let db = Firestore.firestore().collection("parts")
    
    let docID: String
    var binID: Array<[String : Any]>
    let partNumber: String
    let description: String
    let category: String
    let warehouse: String
    
    var partDictionary: [String : Any] {
        return [
            "binID":binID,
            "partNumber":partNumber,
            "description":description,
            "category":category,
            "warehouse":warehouse
        ]
    }
    
    func modifyPartInDB() {
        db.document(self.docID).setData(self.partDictionary) {
            error in
            
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("\(self.description) added sucessfully under ID: \(self.docID)")
                }
        }
    }
    
    static func addPartToDB(partDictiomary: [String: Any]) {
        dbs.collection("parts").document().setData(partDictiomary){
            error in
            
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Added sucessfully")
                }
        }
    }
    
    static func disconnectFromFIRSerivice() {
        print("disabling network")
        dbs.disableNetwork() {
            error in
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("SUCESSFULLY DISABLED NETWORK")
        }
    }
    
    static func loadPartData() {
        dbs.collection("parts").getDocuments() {
            querySnapshot, error in
            
            print("LoadPartData from cache?: \(String(describing: querySnapshot?.metadata.isFromCache))")
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
//                var partArray: [Part]
                allParts = querySnapshot!.documents.compactMap() {
                    Part(docID: $0.documentID, dictionary: $0.data())
                }
                
                for part in allParts {
                    print(part.docID)
                }
            }
        }
    }

    static func checkForUpdates () {
        dbs.collection("parts").addSnapshotListener() {
            querySnapshot, error in
            
           
            guard let docChanges = querySnapshot?.documentChanges
                else {
                    print("no changes found \(error!)")
                    return
            }
            
            docChanges.forEach() {
                doc in
                
                switch doc.type {
                case .modified:
                    print("Doc modified at ID: \(doc.document.documentID)")
                    
                    let updatedPartDocument = doc.document
                    
                    guard let updatedPart = Part(docID: updatedPartDocument.documentID, dictionary: updatedPartDocument.data()),
                        let indexOfPartToUpdateInAllParts = allParts.firstIndex(where: {$0.docID == updatedPart.docID})
                        else {
                            print("Error updating Part in allParts \(String(describing: error?.localizedDescription))")
                            return
                        }
                    
                    allParts[indexOfPartToUpdateInAllParts] = updatedPart
                    
                    
                    print("UPDATE SUCESSFUL: Modified part \(updatedPart.description) - \(updatedPart.partNumber) at allParts[\(indexOfPartToUpdateInAllParts)]")
                    
                case .added:
                    let addedPartDocument = doc.document
                    if let addedPart = Part(docID: addedPartDocument.documentID, dictionary: addedPartDocument.data()) {
                        allParts.append(addedPart)
                        let indexOfPartToAddInAllParts = allParts.firstIndex(where: {$0.docID == addedPart.docID})
                        
                        
                        print("ADD SUCESSFUL: Added part \(addedPart.description) - \(addedPart.partNumber) at allParts[\(String(describing: indexOfPartToAddInAllParts!))]")
                    }
                    else {
                        print("Error adding Part with DocID \(doc.document.documentID) in allParts: ERROR: \(String(describing: error?.localizedDescription))")
                        return
                    }
                case . removed:
                    print("Doc removed as ID: \(doc.document.documentID)")
                    
                    let removedPartDocument = doc.document
                    print(removedPartDocument.data())
                
                    if let indexOfPartToRemoveInAllParts = allParts.firstIndex(where: {$0.docID == doc.document.documentID}) {
                        let removedPart = allParts.remove(at: indexOfPartToRemoveInAllParts)
                        print("REMOVAL SUCESSFUL: Removed part \(removedPart.description) - \(removedPart.partNumber) at allParts[\(String(describing: indexOfPartToRemoveInAllParts))]")
                    }
                    else {
                        print("Error removing Part in allParts \(String(describing: error?.localizedDescription))")
                    }
                    
                @unknown default:
                    print("Unkown switch case in Part.checkForUpdates")
                    
                }
            }
             print("Source from cache?: \(String(describing: querySnapshot?.metadata.isFromCache))")
        }
    }
    

    static func filterContentForSearchText(searchText: String, filterBy: String) {
        if filterBy == "name/description" {
            partFilter = allParts.filter() {
                part in
                return
                    part.description.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").contains(searchText.lowercased().replacingOccurrences(of: " ", with: ""))}
            
                //print("partFilter \(partFilter)")
        } else if filterBy == "partNumber" {
            partFilter = allParts.filter() {
                part in
                return String(part.partNumber).lowercased().replacingOccurrences(of: "-", with: "").contains(searchText.lowercased().replacingOccurrences(of: "-", with: ""))}
            
        } else if filterBy == "power" {
            let powerParts = allParts.filter() {
                part in
                return part.category == "Power"
            }
            partFilter = powerParts.filter() {
            part in
            return String(part.partNumber).lowercased().replacingOccurrences(of: "-", with: "").contains(searchText.lowercased().replacingOccurrences(of: "-", with: ""))
                ||
                part.description.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").contains(searchText.lowercased().replacingOccurrences(of: " ", with: ""))}
            
        } else if filterBy == "hardware" {
            let hardwareParts = allParts.filter() {
                part in
                return part.category.contains("Hardware")
            }
            partFilter = hardwareParts.filter() {
            part in
            return String(part.partNumber).lowercased().replacingOccurrences(of: "-", with: "").contains(searchText.lowercased().replacingOccurrences(of: "-", with: ""))
                ||
                part.description.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").contains(searchText.lowercased().replacingOccurrences(of: " ", with: ""))}
            
        } else if filterBy == "aluminum" {
            let hardwareParts = allParts.filter() {
                part in
                return part.category.contains("Aluminum")
            }
            partFilter = hardwareParts.filter() {
            part in
            return String(part.partNumber).lowercased().replacingOccurrences(of: "-", with: "").contains(searchText.lowercased().replacingOccurrences(of: "-", with: ""))
                ||
                part.description.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\"", with: "").contains(searchText.lowercased().replacingOccurrences(of: " ", with: ""))}
        } else {
            print("unidenified query")
        }
    }

}
    


extension Part: DocumentSerializeable {
    init?(docID: String?, dictionary: [String:Any]) {
            guard let binID = dictionary["binID"] as? [[String: Any]],
                let docID = docID,
                let partNumber = dictionary["partNumber"] as? String,
                let description = dictionary["description"] as? String,
                let category = dictionary["category"] as? String,
                let warehouse = dictionary["warehouse"] as? String
            else {
                return nil
            }
        self.init(docID: docID, binID: binID, partNumber: partNumber, description: description, category: category, warehouse: warehouse)
            
    }
}
    
