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

protocol ThemeObserver {
    var realm: Realm { get }
    var observableTheme: Observable<Theme>! { get }
    var bag: DisposeBag { get }
    
    func subscribeToNewTheme() -> Observable<Theme>
    func observeNewTheme()
}

extension ThemeObserver {
    
    func subscribeToNewTheme() -> Observable<Theme> {
//        let themes = realm.objects(Theme.self)
        let theme = realm.object(ofType: Theme.self, forPrimaryKey: "0")
        if let theme = theme {
            return Observable.from(object: theme)
        } else {
            let firstTheme = Theme.themes[0] // Ferrari. Is guaranteed to exist.
            try! realm.write {
                realm.add(firstTheme, update: true)
            }
            return Observable.from(object: firstTheme)
        }
    }
}

extension ThemeObserver where Self: UINavigationController {
    func observeNewTheme() {
        observableTheme.subscribe(onNext: { [unowned self] (theme) in
            let foregroundColour = UIColor(theme.foregroundColour)
            
            let textAttributes = [NSAttributedString.Key.foregroundColor: foregroundColour]
            
            self.navigationBar.titleTextAttributes      = textAttributes
            self.navigationBar.largeTitleTextAttributes = textAttributes
            
            self.navigationBar.tintColor = foregroundColour
            self.navigationBar.barTintColor = UIColor(theme.backgroundColour)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: bag)
    }
}

extension ThemeObserver where Self: UITabBarController {
    func observeNewTheme() {
        observableTheme.subscribe(onNext: { [unowned self] (theme) in
            self.tabBar.tintColor = UIColor(theme.foregroundColour)
            self.tabBar.barTintColor = UIColor(theme.backgroundColour)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
}
