//
//  LoadingRow.swift
//  Framework Demo
//
//  Created by James Coleman on 02/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import Eureka

public final class LoadingCell: Cell<UIView>, CellType {
    public override func setup() {
        super.setup()
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        height = {
            let tableHeight = self.formViewController()?.tableView.frame.size.height ?? 44
            let navHeight = self.formViewController()?.navigationController?.navigationBar.frame.maxY ?? 0 // Use frame.maxY to easily account for status bar
            let tabHeight = self.formViewController()?.tabBarController?.tabBar.frame.height ?? 0
            return tableHeight - navHeight - tabHeight
        }
        
        selectionStyle = .none
    }
}

public final class LoadingRow: Row<LoadingCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}


