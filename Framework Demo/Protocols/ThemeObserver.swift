//
//  ThemeObserver.swift
//  Framework Demo
//
//  Created by James Coleman on 16/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm

protocol ThemeObserver {
    var viewModel: ThemeProvider { get }
    var bag: DisposeBag { get }
    
    func observeNewTheme()
}

extension ThemeObserver where Self: UINavigationController {
    func observeNewTheme() {
        viewModel.observableTheme.subscribe(onNext: { [unowned self] (theme) in
            let foregroundColour = UIColor(theme.foregroundColour)
            
            let textAttributes = [NSAttributedString.Key.foregroundColor: foregroundColour]
            
            self.navigationBar.titleTextAttributes      = textAttributes
            self.navigationBar.largeTitleTextAttributes = textAttributes
            
            self.navigationBar.tintColor = foregroundColour
            self.navigationBar.barTintColor = UIColor(theme.backgroundColour)
            self.navigationBar.barStyle = theme.statusBarWhite ? .black : .default
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
}

extension ThemeObserver where Self: UITabBarController {
    func observeNewTheme() {
        viewModel.observableTheme.subscribe(onNext: { [unowned self] (theme) in
            self.tabBar.tintColor = UIColor(theme.foregroundColour)
            self.tabBar.barTintColor = UIColor(theme.backgroundColour)
            self.tabBar.unselectedItemTintColor = UIColor(white: theme.statusBarWhite ? 1 : 0, alpha: 0.5)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
}
