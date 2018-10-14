//
//  AppNavCon.swift
//  Framework Demo
//
//  Created by James Coleman on 30/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class AppNavCon: UINavigationController, ThemeObserver {
    var bag = DisposeBag()
    
    var viewModel: ThemeProvider = AppNavViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBar.prefersLargeTitles    = true
        navigationBar.isOpaque              = false
        
        observeNewTheme()
    }

}

struct AppNavViewModel: ThemeProvider {
    let realm = try! Realm()
}
