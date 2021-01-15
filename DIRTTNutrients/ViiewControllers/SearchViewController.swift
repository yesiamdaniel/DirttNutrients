//
//  NameSearchViewController.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-21.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//
// TODO: find way to hide cancel button

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

// Initializing UI elements to recieve from HomeScreenViewController or CategorySelectorVC
    var filterBy: String = ""
    var navBarTitle: String = ""
    var backgroundColor: UIColor = UIColor()
    var searchBarColor: UIColor = UIColor()
    var isFilteringByCategory: Bool = false
    
// Initializing searchController, searchBar, and searchBarTextField
    let searchController = UISearchController(searchResultsController: nil)
    private let refreshController = UIRefreshControl()
    lazy var searchBar = searchController.searchBar
    lazy var searchBartextfield = searchBar.value(forKey: "searchField") as! UITextField
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
// Sets the navBar title
        setNavBar(title: navBarTitle)
        
// Assigns table view delegates and initalizes other functionalty elements
        setTableView()
        
// Set background color of view
        view.backgroundColor = backgroundColor
 
// Handles primary searchController initalization
        setSearchController()
        setSearchBarPrompt()
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // Allows cancel button to disappear when scrolling
        if (searchBar.text?.isEmpty)! {
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
    
    
    // Creates navbar title
    private func setNavBar(title: String)  {
        let fontSize: CGFloat = 28
        let font: UIFont = UIFont.preferredFont(forTextStyle: .headline).withSize(fontSize)
        
        // Sets fonts and atributes
        let attributes: [NSAttributedString.Key:Any] = [
            .font : font,
        ]
        
        // Assigns color of title and creates NSAttributedString
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        let titleAttrib: NSAttributedString = NSAttributedString(string: title, attributes: attributes)
        
        // Assigns attributes to titleLabel and assigns title label to the titleview of navigation header
        titleLabel.attributedText = titleAttrib
        navigationItem.titleView = titleLabel
    }
    
    private func setSearchController() {
        // Assign the created UISearchController to the navigationItem (creates the searchBar)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    
        searchBar.tintColor = .white
        
        // Sets properties of text field in searchBar
        searchBartextfield.textColor = UIColor.white
        if let searchBarTextFieldBackgroundView = searchBartextfield.subviews.first {
            searchBarTextFieldBackgroundView.backgroundColor = searchBarColor
            searchBarTextFieldBackgroundView.layer.cornerRadius = 10
            searchBarTextFieldBackgroundView.clipsToBounds = true
        }
    }
    
    private func setSearchBarPrompt() {
        if isFilteringByCategory {
            let totalNumberOfPartsInTable = Part.allParts.filter() {$0.category.lowercased() == filterBy.lowercased()}.count
            searchBartextfield.placeholder =  "Search \(String(totalNumberOfPartsInTable)) Parts"
        } else {
            let totalNumberOfPartsInTable = Part.allParts.count
            searchBartextfield.placeholder = "Search \(String(totalNumberOfPartsInTable)) Parts"
        }
    }
    
// Returns true if searchBar is empty
    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
// Returns true if searchController is actvive
    private func isFiltering() -> Bool {
        setNavBar(title: navBarTitle)
        return searchController.isActive && !searchBarIsEmpty()
    }
    

}



// MARK: Extensions

extension SearchViewController: UISearchResultsUpdating {
    // Conforming NameSearchViewController to the protocol UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        searchBar.setShowsCancelButton(true, animated: true)
        print("FILTERING?: \(isFiltering())")
        print("CURRENT SEACHBAR TEXT: \(searchBar.text!)")
        Part.filterContentForSearchText(searchText: searchBar.text!, filterBy: filterBy)

        
        tableView.reloadData()
        
        
        
    
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
// Assigns the table view datasource and delegate to self
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
      
// Add the refresh control to  tableView .
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
        if isFiltering() {
            Part.filterContentForSearchText(searchText: searchBar.text!, filterBy: filterBy)
        }
        tableView.reloadData()
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
        }
    }
      

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return Part.partFilter.count
        } else if isFilteringByCategory{
            return Part.allParts.filter() {$0.category.lowercased() == filterBy.lowercased()}.count
        } else {
            return Part.allParts.count
        }
    }
    
    // Set up table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseableCell", for: indexPath) as! CustomTableViewCellForSearch
        
        let cellHeight = cell.bounds.height
        tableView.rowHeight = cellHeight
        
        var partAtRow: Part
        if isFiltering() {
            partAtRow = Part.partFilter[indexPath.row]
        } else if isFilteringByCategory {
            partAtRow = Part.allParts.filter() {$0.category.lowercased().contains(filterBy.lowercased())}[indexPath.row]
        }
        else {
            partAtRow = Part.allParts[indexPath.row]
        }
        
        cell.styleDescriptionLabels()
        cell.styleBackgroundView(bgColor: backgroundColor)
        cell.partAtCell = partAtRow
        cell.createCell()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
// Resigns searchBar firstResponder status
        searchBar.endEditing(true)
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        
        let cellInfo = tableView.cellForRow(at: indexPath) as? CustomTableViewCellForSearch
        
        guard let part = cellInfo?.partAtCell
        else {
            print("ERR: no part found in selected cell")
            return
        }
        detailVC.partDocID = part.docID
        detailVC.backgroundColor = backgroundColor
        detailVC.sectionColor = searchBarColor
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
    
}


