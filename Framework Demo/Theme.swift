//
//  Theme.swift
//  Framework Demo
//
//  Created by James Coleman on 13/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Theme: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColour: Int = 0
    @objc dynamic var foregroundColour: Int = 0
    @objc dynamic var primaryKeyString: String = "0" // All Themes
    
    override static func primaryKey() -> String {
        return "primaryKeyString"
    }
}

struct ThemeData {
    let name: String
    let backgroundColour: Int
    let foregroundColour: Int
    let statusBarWhite: Bool
    
    static let themes: [ThemeData] = [
        ThemeData(name: "Scuderia Ferrari",                 backgroundColour: 0xEB3223, foregroundColour: 0xffffff, statusBarWhite: true),
        ThemeData(name: "Force India",                      backgroundColour: 0xF4B2C7, foregroundColour: 0xE438AD, statusBarWhite: true),
        ThemeData(name: "Haas",                             backgroundColour: 0x585858, foregroundColour: 0xDA3731, statusBarWhite: true),
        ThemeData(name: "McLaren",                          backgroundColour: 0xF08134, foregroundColour: 0x00137E, statusBarWhite: true),
        ThemeData(name: "Mercedes",                         backgroundColour: 0xc3c3c3, foregroundColour: 0x80fbd8, statusBarWhite: true),
        ThemeData(name: "Red Bull Racing",                  backgroundColour: 0x000843, foregroundColour: 0xda3731, statusBarWhite: true),
        ThemeData(name: "Renault",                          backgroundColour: 0xfef051, foregroundColour: 0x000000, statusBarWhite: true),
        ThemeData(name: "Sauber",                           backgroundColour: 0xffffff, foregroundColour: 0x7d1620, statusBarWhite: true),
        ThemeData(name: "Scuderia Toro Rosso",              backgroundColour: 0x002bf5, foregroundColour: 0xda3731, statusBarWhite: true),
        ThemeData(name: "Williams Grand Prix Engineering",  backgroundColour: 0xffffff, foregroundColour: 0x00137e, statusBarWhite: true)
    ]
}
