//
//  ThemeProvider.swift
//  Framework Demo
//
//  Created by James Coleman on 13/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import RxSwift
import RealmSwift
import RxRealm

protocol ThemeProvider {
    var realm: Realm { get } // This could be split into a procotol e.g. RealmProvider
    var observableTheme: Observable<Theme> { get }
}

extension ThemeProvider {
    var observableTheme: Observable<Theme> {
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



