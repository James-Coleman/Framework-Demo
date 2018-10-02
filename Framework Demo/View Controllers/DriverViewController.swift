//
//  DriverViewController.swift
//  Framework Demo
//
//  Created by James Coleman on 01/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import Eureka

class DriverViewController: FormViewController {

    private var viewModel: DriverViewModel
    
    init(viewModel: DriverViewModel) {
        self.viewModel = viewModel
        super.init(style: UITableView.Style.grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Driver"
        
        let plainSection = Section(header: "", footer: "")
        plainSection.header?.height = { CGFloat.leastNormalMagnitude }
        plainSection.footer?.height = { CGFloat.leastNormalMagnitude }
        
        form
            +++ plainSection
            <<< LoadingRow()
        
        /*
        form
            +++ Section()
            <<< TextFloatLabelRow() { row in
                row.title = "Name"
                row.value = "Lewis Hamilton"
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "TLA"
                row.value = "HAM"
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "Date of Birth"
                row.value = "1st January 1970"
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "Age"
                row.value = "48"
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "Nationality"
                row.value = "British"
                row.disabled = true
        }
        */
    }

}
