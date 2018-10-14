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
import RealmSwift

class SettingsViewController: FormViewController {
    
//    private var viewModel = SettingsViewModel()

    private var realm = try! Realm()
    private var theme: Theme!
    
    private func setDoneButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        navigationItem.setRightBarButton(button, animated: false)
    }
    
    @objc
    private func tappedDone() {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Settings"
        
        setDoneButton()
        navigationItem.hidesBackButton = true
        
        theme = realm.object(ofType: Theme.self, forPrimaryKey: "0")
        
        let dataSource = ThemeData.themes
        
        let themeRows = dataSource.map { (theme) -> ListCheckRow<String> in
            return ListCheckRow<String>(theme.name) { row in
                row.title = theme.name
                row.selectableValue = theme.name
                row.value = self.theme.name == theme.name ? theme.name : nil
            }
        }
        
        let themeSection = SelectableSection<ListCheckRow<String>>("Theme", selectionType: .singleSelection(enableDeselection: false))
        themeSection.append(contentsOf: themeRows)
        themeSection.onSelectSelectableRow = { [unowned self] (cell, row) in
            guard let indexPath = themeSection.selectedRow()?.indexPath else { return }
            let theme = dataSource[indexPath.row]
            try! self.realm.write {
                self.theme.name = theme.name
                self.theme.backgroundColour = theme.backgroundColour
                self.theme.foregroundColour = theme.foregroundColour
                self.theme.statusBarWhite = theme.statusBarWhite
//                self.realm.add(theme, update: true)
            }
        }
        
        form
            +++ themeSection
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
