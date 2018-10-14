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
    var realm = try! Realm()
    var observableTheme: Observable<Theme>!
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBar.prefersLargeTitles       = true
        navigationBar.isOpaque = false
        
        observableTheme = subscribeToNewTheme()
        observeNewTheme()
    }

}
