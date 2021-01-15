//
//  ViewController.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-07-13.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    
    @IBOutlet weak var searchByNum: UIButton!
    @IBOutlet weak var searchByCat: UIButton!
    @IBOutlet weak var searchByName: UIButton!
    
    var button1ThemeColors = [#colorLiteral(red: 0, green: 0.4862745098, blue: 0.6980392157, alpha: 1), #colorLiteral(red: 0, green: 0.2156862745, blue: 0.3882352941, alpha: 1)]
    var button2ThemeColors = [#colorLiteral(red: 0.6187899113, green: 0.6187899113, blue: 0.6187899113, alpha: 1), #colorLiteral(red: 0.2348319888, green: 0.2348319888, blue: 0.2348319888, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButton()
        colorButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Main screen disappears
        super.viewDidDisappear(animated)
        // Hides navigation bar on main screen
        navigationController?.setNavigationBarHidden(false, animated: true)
        // Removes tint from navbar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // Removes line from navbar
        navigationController?.navigationBar.shadowImage = UIImage()
        // Sets nav bar elements to white unless property is change in VC
        navigationController?.navigationBar.tintColor = UIColor.white
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            if let searchViewController = segue.destination as? SearchViewController {
                // print("Segue dest: Sucess!") //
                if let senderButton = sender as? UIButton {
                    searchViewController.filterBy = senderButton.accessibilityLabel ?? "error: segue"
                    searchViewController.navBarTitle = senderButton.titleLabel?.text ?? "error: segue"
                    searchViewController.backgroundColor = senderButton.backgroundColor ?? UIColor.blue
                    var searchBarColor: UIColor {
                        switch senderButton.backgroundColor! {
                        case button1ThemeColors[0]: return button1ThemeColors[1]
                        case button2ThemeColors[0]: return button2ThemeColors[1]
                        default: return UIColor.black
                        }
                    }
                    searchViewController.searchBarColor = searchBarColor
                }
            }
        }
    }
    
    
    private func roundButton () {
        searchByName.layer.cornerRadius = 20
        searchByNum.layer.cornerRadius = 20
        searchByCat.layer.cornerRadius = 20
    }
    
    private func colorButton() {
        searchByName.backgroundColor = button1ThemeColors[0]
        searchByNum.backgroundColor = button2ThemeColors[0]
    }
}

