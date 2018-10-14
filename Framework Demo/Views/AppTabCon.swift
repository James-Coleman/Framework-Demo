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
    var bag = DisposeBag()
    
    var viewModel: ThemeProvider = AppTabViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabBar.isOpaque = false
        
        observeNewTheme()
    }
}

struct AppTabViewModel: ThemeProvider {
    let realm = try! Realm()
}
