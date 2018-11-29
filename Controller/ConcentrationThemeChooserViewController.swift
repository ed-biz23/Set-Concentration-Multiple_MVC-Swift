//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Sameh on 10/24/18.
//  Copyright © 2018 Sameh. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports"   : "⚽️🏀🏈⚾️🎾🏐🏓🏸🏒🚴‍♀️🚣‍♀️🏏",
        "Animals"  : "🐶🐱🐭🦊🦁🐸🐔🦑🕷🐙🐖",
        "Faces"    : "😀😙😛🤣😇😎😡🤡👹🤠",
        ]
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let button = sender as? UIButton {
                if let theme = button.currentTitle {
                    if let theme = themes[theme] {
                        cvc.theme = theme
                    }
                }
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let button = sender as? UIButton {
                if let theme = button.currentTitle {
                    if let theme = themes[theme] {
                        cvc.theme = theme
                    }
                }
            }
            navigationController?.pushViewController(cvc,
                                                     animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton {
                if let themeName = button.currentTitle {
                    if let theme = themes[themeName] {
                        if let cvc = segue.destination as? ConcentrationViewController {
                            cvc.theme = theme
                            lastSeguedToConcentrationViewController = cvc
                        }
                    }
                }
            }
        }
    }
    
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
}
