//
//  SettingsViewController.swift
//  Framework Demo
//
//  Created by James Coleman on 13/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import Eureka
import Hero

class SettingsViewController: FormViewController {

    private func setDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationItem.setLeftBarButton(button, animated: false)
    }
    
    @objc
    private func tappedDone() {
//        dismiss(animated: true)
        hero.dismissViewController()
//        hero.dismissViewController { [weak self] in
//            self?.navigationController?.hero.isEnabled = false
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Theme"
        
        setDoneButton()
        
        form +++
            SelectableSection<ListCheckRow<String>>("", selectionType: .singleSelection(enableDeselection: false))
            <<< ListCheckRow<String>("Mercedes") { row in
                row.title = "Mercedes"
                row.selectableValue = "Mercedes"
                row.value = nil
            }
            <<< ListCheckRow<String>("Sauber") { row in
                row.title = "Sauber"
                row.selectableValue = "Sauber"
                row.value = nil
            }
            <<< ListCheckRow<String>("Williams") { row in
                row.title = "Williams"
                row.selectableValue = "Williams"
                row.value = nil
        }
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
