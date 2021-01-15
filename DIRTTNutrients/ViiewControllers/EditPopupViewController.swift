//
//  EditPopupViewController.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-08-01.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class EditPopupViewController: UIViewController {

    @IBOutlet weak var editHeadline: UILabel!
    @IBOutlet weak var currentStateLabel: UILabel!
    @IBOutlet weak var newEditPromptLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    var elementToEdit: String?
    var editHeadlineText: String?
    var currentStateText: String?
    var newEditPromptText: String?
    var binIndex: Int!
  
    var tableView: UITableView?
    
    var partIndex: Int!
    lazy var partSelected = Part.allParts[partIndex]
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        textField.endEditing(true)
        handleUpdate(newValue: textField.text!, for: elementToEdit, at: binIndex)
        
        let alert = UIAlertController(title: "Update Success!", message: "Successfully updated \(elementToEdit!) for Part: \(partSelected.partNumber)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
            { action in
  
                self.dismiss(animated: true)
                self.updateTable(tableView: self.tableView!)
            }))
        
        self.present(alert, animated: true)
    }
  
    
    var sectionColor: UIColor = UIColor()
    var cellColor: UIColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLabels()
        styleButtons()
        styleTextField()
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    private func styleButtons() {
        cancelButtonOutlet.layer.cornerRadius = 20
        submitButtonOutlet.layer.cornerRadius = 20
        
        
    }
    
    private func styleLabels() {
        editHeadline.backgroundColor = sectionColor
        editHeadline.text = editHeadlineText
        
        currentStateLabel.backgroundColor = cellColor
        currentStateLabel.text = currentStateText
        
        newEditPromptLabel.backgroundColor = sectionColor
        newEditPromptLabel.text = newEditPromptText

        backgroundView.backgroundColor = sectionColor
        backgroundView.layer.cornerRadius = 20
        
    }
    
    private func styleTextField() {
        textField.backgroundColor = cellColor
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter new value"
        if elementToEdit == "quantity" {
           textField.keyboardType = UIKeyboardType.numberPad
        } else {
            textField.keyboardType = UIKeyboardType.asciiCapable
        }
        
    }

    private func handleUpdate(newValue: String, for: String?, at binIndex: Int) {
        if newValue == "" {
            print("New value must not be blank before sumbitting")
        }
        else if elementToEdit == nil {
            print("Error: Element to edit not defined")
        }
        else if elementToEdit! == "quantity" {
            
            if let newQuantity = Int(newValue) {
                
                partSelected.binID[binIndex]["qty"] = newQuantity
                partSelected.modifyPartInDB()
            }
               
        } else if elementToEdit! == "location" {
            
            let newLocation = newValue
            
            partSelected.binID[binIndex]["location"] = newLocation
            partSelected.modifyPartInDB()
            self.partSelected = Part.allParts[partIndex]
        }
    }
    
    func updateTable(tableView: UITableView) {
        self.tableView = tableView
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}


