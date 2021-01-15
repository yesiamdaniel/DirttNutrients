//
//  DetailViewController.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-28.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var labelBackground: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var partNumberLabel: UILabel!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true) {print("Dismissed DetailViewController")}
        
       
    }
    
    var backgroundColor: UIColor = UIColor()
    var sectionColor: UIColor = UIColor()
    
    var partDocID: String?
    lazy var partIndex: Int = Part.allParts.firstIndex(where: {$0.docID == self.partDocID})!
    
    lazy var partSelected: Part = Part.allParts[partIndex]
    var partEditedFromPopup: Part? 
    
    let refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleBackgroundView()
        styleLabels()
        styleButton()
        setTableView()
        definesPresentationContext = true
        self.modalPresentationStyle = .overFullScreen
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view appearing")
    }
    
    private func styleBackgroundView() {
        labelBackground.layer.cornerRadius = 20
        view.backgroundColor = backgroundColor
    }
    
    private func styleButton() {
        backButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
    }
    
    private func styleLabels() {
        let part = partSelected
        
        let partNumberLabelAtrributes: [NSAttributedString.Key:Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .strokeColor: UIColor.black,
            .strokeWidth: -3,
        ]
        
        partNumberLabel.attributedText = NSAttributedString(string: part.partNumber
            , attributes: partNumberLabelAtrributes)
        
        descriptionLabel.text = part.description
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        tableView.addSubview(refreshController)
           // refreshControl customization
               let attributes: [NSAttributedString.Key:Any] = [
                   .strokeWidth : -5,
                   .strokeColor : UIColor.white
               ]
               refreshController.backgroundColor = backgroundColor
               refreshController.attributedTitle = NSAttributedString(string: "Pull To Refresh", attributes: attributes)
               refreshController.addTarget(self, action:
                   #selector(handleRefreshControl),for: .valueChanged)
               
    }
           
   @objc func handleRefreshControl() {
       // Update your content…
       tableView.reloadData()
       // Dismiss the refresh control.
       DispatchQueue.main.async {
           self.refreshController.endRefreshing()
       }
   }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        sectionView.backgroundColor = sectionColor
        
        quantityLabel.textColor = .white
        locationLabel.textColor = .white
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partSelected.binID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as! CustomTableViewCellForDetail
        
        print("reloading data")
        cell.binID = Part.allParts[partIndex].binID[indexPath.row]
      
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.createCell()
        cell.backgroundColor = sectionColor
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let binEditAction: UIContextualAction = editActionHandle(editing: "location", at: indexPath)
        let quantityEditAction: UIContextualAction = editActionHandle(editing: "quantity", at: indexPath)
        let config = UISwipeActionsConfiguration(actions: [binEditAction, quantityEditAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
   
    func editActionHandle(editing elementToEdit: String, at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "EDIT \(elementToEdit.uppercased())") { (UIContextualAction, view, completion) in
                
                let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "EditPopupViewController") as! EditPopupViewController
                
                
                popupVC.elementToEdit = elementToEdit
                popupVC.partSelected = self.partSelected
                popupVC.binIndex = indexPath.row
                popupVC.sectionColor = self.sectionColor
                popupVC.cellColor = self.backgroundColor
                popupVC.editHeadlineText = "Previous \(elementToEdit):"
                popupVC.newEditPromptText = "New \(elementToEdit):"
                
                var binIDField = ""
                if elementToEdit == "quantity" {
                    binIDField = "qty"
                } else {
                    binIDField = "location"
                }
                
                if let currentElementState = self.partSelected.binID[indexPath.row][binIDField] as? String {
                    popupVC.currentStateText = currentElementState
                } else if let currentElementState = self.partSelected.binID[indexPath.row][binIDField] as? Int {
                    popupVC.currentStateText = String(currentElementState)
                } else {
                    popupVC.currentStateText = "*ERROR* Ref. editActionHandle"
                }
                
                popupVC.updateTable(tableView: self.tableView)
                self.present(popupVC, animated: true)
            }
        
        if elementToEdit == "quantity" {
            action.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            action.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
        
        return action
    }
}
