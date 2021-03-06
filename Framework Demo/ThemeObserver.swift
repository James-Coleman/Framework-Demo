//
//  ThemeObserver.swift
//  Framework Demo
//
//  Created by James Coleman on 13/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm

protocol ThemeProvider {
    var realm: Realm { get }
    var observableTheme: Observable<Theme>! { get }
    var bag: DisposeBag { get }
    
    func subscribeToNewTheme() -> Observable<Theme>
    func observeNewTheme()
}

extension ThemeProvider {
    
    func subscribeToNewTheme() -> Observable<Theme> {
//        let themes = realm.objects(Theme.self)
        let theme = realm.object(ofType: Theme.self, forPrimaryKey: "0")
        if let theme = theme {
            return Observable.from(object: theme)
        } else {
            let firstTheme = ThemeData.themes[0] // Ferrari. Is guaranteed to exist. This isn't an `if let` to allow for easily always returning something
            let theme = Theme()
            theme.name = firstTheme.name
            theme.backgroundColour = firstTheme.backgroundColour
            theme.foregroundColour = firstTheme.foregroundColour
            theme.statusBarWhite = firstTheme.statusBarWhite
            try! realm.write {
                realm.add(theme, update: true)
            }
            return Observable.from(object: theme)
        }
    }
}

extension ThemeProvider where Self: UINavigationController {
    func observeNewTheme() {
        observableTheme.subscribe(onNext: { [unowned self] (theme) in
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

extension ThemeProvider where Self: UITabBarController {
    func observeNewTheme() {
        observableTheme.subscribe(onNext: { [unowned self] (theme) in
            self.tabBar.tintColor = UIColor(theme.foregroundColour)
            self.tabBar.barTintColor = UIColor(theme.backgroundColour)
            self.tabBar.unselectedItemTintColor = UIColor(white: theme.statusBarWhite ? 1 : 0, alpha: 0.5)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
}
