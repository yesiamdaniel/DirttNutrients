//
//  AdminViewController.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-08-06.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    @IBOutlet weak var partDescriptionText: UITextField!
    @IBOutlet weak var partNumberText: UITextField!
    @IBOutlet weak var partCategory: UITextField!
    
    @IBOutlet weak var binLocation1: UITextField!
    @IBOutlet weak var binQuantity1: UITextField!
    
    @IBOutlet weak var binLocation2: UITextField!
    @IBOutlet weak var binQuantity2: UITextField!
    
    @IBOutlet weak var binLocation3: UITextField!
    @IBOutlet weak var binQuantity3: UITextField!
    
    @IBOutlet weak var binLocation4: UITextField!
    @IBOutlet weak var binQuantity4: UITextField!
    
    @IBOutlet weak var binLocation5: UITextField!
    @IBOutlet weak var binQuantity5: UITextField!
    
    @IBOutlet weak var binLocation6: UITextField!
    @IBOutlet weak var binQuantity6: UITextField!
    
    lazy var mandatoryFields = [
        partDescriptionText,
        partNumberText,
        partCategory,
        binLocation1,
        binQuantity1
    ]
    
    lazy var bins = [
        [binLocation1: binQuantity1],
        [binLocation2: binQuantity2],
        [binLocation3: binQuantity3],
        [binLocation4: binQuantity4],
        [binLocation5: binQuantity5],
        [binLocation6: binQuantity6]
    ]
    
    
    @IBAction func DONE(_ sender: Any) {
        if !verifyInput() {
            let alert = UIAlertController(title: "BAD Input", message: "A mandatory field was left empty, or category is no conforming", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let partNumber: String = partNumberText.text!
        let partDescription: String = partDescriptionText.text!
        let category: String  = partCategory.text!
        let warehouse: String = "CGY"
        
        
   
        
        var binID: Array<[String : Any]>? {
            var binIDs = Array<[String: Any]>()
            for bin in bins {
                if bin.keys.first??.text != "" || bin.values.first??.text != "" {
                    let key = bin.keys.first!!.text!
                    if let value = Int(bin.values.first!!.text!) {
                        let dict: [String : Any] = ["location": key, "qty": value]
                        binIDs.append(dict)
                    } else {
                        let alert = UIAlertController(title: "BAD Input", message: "Inavlid input for quantity", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Go Back", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return nil
                    }
                }
            }
            return binIDs
        }
        
        if binID == nil {return}
        
        var partDictionary: [String : Any] {
            return [
                "binID":binID!,
                "partNumber":partNumber,
                "description":partDescription,
                "category":category,
                "warehouse":warehouse
            ]
        }
    
        
        Part.addPartToDB(partDictiomary: partDictionary)
        let alert = UIAlertController(title: "Success", message: "Successfully Added Part to DB", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Clear Text", style: .default, handler: {
            action in
            self.clearFields()
        }))
        present(alert, animated: true, completion: nil)
    }


        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func verifyInput() -> Bool {
        for field in mandatoryFields {
            if field?.text == "" {return false}
        }
        switch partCategory.text! {
        case "Power":
            return true
        case "Hardware":
            return true
        case "Hardware Legacy":
            return true
        case "Hardware Wood":
            return true
        case "Plastics DC":
            return true
        case "Aluminum":
            return true
        default:
            return false
        }
    }
    
    private func clearFields() {
        partDescriptionText.text = ""
        partNumberText.text = ""
        partCategory.text = ""
        binLocation1.text = ""
        binQuantity1.text = ""
        binLocation2.text = ""
        binQuantity2.text = ""
        binLocation3.text = ""
        binQuantity3.text = ""
        binLocation4.text = ""
        binQuantity4.text = ""
        binLocation5.text = ""
        binQuantity5.text = ""
        binLocation6.text = ""
        binQuantity6.text = ""
    }
    
}

extension AdminViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
