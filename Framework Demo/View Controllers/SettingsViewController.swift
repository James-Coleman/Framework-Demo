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
        let buttonOld = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        let button = UIBarButtonItem(image: UIImage(named: "Settings Cog Upside Down"), style: .plain, target: self, action: #selector(tappedDone))
        button.customView?.hero.id = "button"
        
        let navHeight = navigationController!.navigationBar.frame.maxY
        
        let buttonNew = UIButton(frame: CGRect(x: 360, y: navHeight + 12, width: 24, height: 24))
        buttonNew.setImage(UIImage(named: "Settings Cog Upside Down"), for: .normal)
        buttonNew.addTarget(self, action: #selector(tappedDone), for: .touchUpInside)
        buttonNew.hero.modifiers = [.rotate(CGFloat(Double.pi)), .useGlobalCoordinateSpace]
        view.addSubview(buttonNew)
        
        let button2 = UIBarButtonItem(customView: buttonNew)
        button.customView?.hero.modifiers = [.rotate(CGFloat(Double.pi)), .useGlobalCoordinateSpace]
//        button2.customView?.hero.id = "button2"
//        button2.customView?.hero.modifiers = [.rotate(CGFloat(2 * Double.pi)), .useGlobalCoordinateSpace]
        
        navigationItem.setRightBarButton(button, animated: false)
//        navigationItem.setRightBarButton(button2, animated: false)

    }
    
    @objc
    private func tappedDone() {
        hero.dismissViewController()
//        navigationController?.popViewController(animated: false)
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
