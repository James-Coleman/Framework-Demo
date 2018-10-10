//
//  UITableView Extensions.swift
//  Framework Demo
//
//  Created by James Coleman on 10/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit

extension UITableView {
    public func setPlaceholder(to view: UIView?) {
        if let view = view {
            backgroundView = view
            separatorStyle = .none
            isScrollEnabled = false
        } else {
            backgroundView = nil
            separatorStyle = .singleLine
            isScrollEnabled = true
        }
    }
}
