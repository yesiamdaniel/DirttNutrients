//
//  CategorySelectorViewController.swift
//  DirttInventoryChecker
//
//  Created by Philipine Appiah on 2019-08-05.
//  Copyright © 2019 Daniel Appiah. All rights reserved.
//

import UIKit

class CategorySelectorViewController: UIViewController {

    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var hardwareButton: UIButton!
    @IBOutlet weak var aluminumButton: UIButton!
    
    var powerButtonThemeColors: [UIColor] = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 1, green: 0.5, blue: 0, alpha: 1)]
    var hardwareButtonThemeColors: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)]
    var aluminumButtonThemeColors: [UIColor] = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.3793114596, blue: 0.9556350602, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButtons()
        colorButtons()
        titleButtons()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        navigationItem.backBarButtonItem = backItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "search" {
              if let searchViewController = segue.destination as? SearchViewController {
          
                if let senderButton = sender as? UIButton {
                    
                    searchViewController.filterBy = senderButton.accessibilityLabel ?? "error: segue"
                    searchViewController.isFilteringByCategory = true
                    searchViewController.navBarTitle = senderButton.titleLabel?.text ??
                        "error segue"
                    searchViewController.backgroundColor = senderButton.backgroundColor ?? UIColor.blue
                    
                    var searchBarColor: UIColor {
                      switch senderButton.accessibilityLabel! {
                      case "power": return powerButtonThemeColors[1]
                      case "hardware": return hardwareButtonThemeColors[1]
                      case "aluminum": return aluminumButtonThemeColors[1]
                      default: return UIColor.black
                      }
                    }
                    searchViewController.searchBarColor = searchBarColor
                    
                    
                }
            }
        }
    }
    
    
    
    private func roundButtons() {
        powerButton.layer.cornerRadius = 20
        hardwareButton.layer.cornerRadius = 20
        aluminumButton.layer.cornerRadius = 20
    }
    
    private func colorButtons() {
        powerButton.backgroundColor = powerButtonThemeColors[0]
        hardwareButton.backgroundColor = hardwareButtonThemeColors[0]
        aluminumButton.backgroundColor = aluminumButtonThemeColors[0]
        
        powerButton.tintColor = .white
        hardwareButton.tintColor = .white
        aluminumButton.tintColor = .white
    }
    
    private func titleButtons() {
        powerButton.setTitle("Power", for: .normal)
        hardwareButton.setTitle("Hardware", for: .normal)
        aluminumButton.setTitle("Aluminum", for: .normal)
    }

    

}
