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
        title = viewModel.driver.familyName
        
        /*
        let plainSection = Section(header: "", footer: "")
        plainSection.header?.height = { CGFloat.leastNormalMagnitude }
        plainSection.footer?.height = { CGFloat.leastNormalMagnitude }
        
        form
            +++ plainSection
            <<< LoadingRow()
        */
        
        form
            +++ Section()
            <<< TextFloatLabelRow() { row in
                row.title = "Full Name"
                row.value = viewModel.driver.fullName
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "TLA"
                row.value = viewModel.driver.code
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "Date of Birth"
                row.value = viewModel.driver.stringDateOfBirth
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "Age"
                row.value = ""
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "Nationality"
                row.value = viewModel.driver.nationality
                row.disabled = true
            }
            <<< TextFloatLabelRow() { row in
                row.title = "More Info"
                row.value = viewModel.driver.stringUrl
                row.disabled = true
                row.onCellSelection({ [unowned self] (cell, row) in
                    self.viewModel.selectedUrl()
                })
        }
    }

}
