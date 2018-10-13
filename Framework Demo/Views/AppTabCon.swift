//
//  AppTabCon.swift
//  Framework Demo
//
//  Created by James Coleman on 01/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class AppTabCon: UITabBarController, ThemeObserver {
    var realm = try! Realm()
    var observableTheme: Observable<Theme>!
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabBar.barTintColor = .red
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = UIColor(white: 1, alpha: 0.5)
        tabBar.isOpaque = false
        
        observableTheme = subscribeToNewTheme()
        observeNewTheme()
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
