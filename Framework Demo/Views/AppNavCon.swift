//
//  AppNavCon.swift
//  Framework Demo
//
//  Created by James Coleman on 30/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit

class AppNavCon: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationBar.titleTextAttributes      = textAttributes
        navigationBar.largeTitleTextAttributes = textAttributes
        navigationBar.barTintColor             = .red
        navigationBar.tintColor                = .white
        navigationBar.prefersLargeTitles       = true
    }

}
