//
//  DriverViewController.swift
//  Framework Demo
//
//  Created by James Coleman on 01/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import Eureka
import RxSwift

class DriverViewController: FormViewController {
    
    private var viewModel: DriverViewModel
    
    private enum DriverRowName: String {
        case image, name, tla, dob, age, nationality, moreInfo
    }
    
    private let bag = DisposeBag()
    
    init(viewModel: DriverViewModel) {
        self.viewModel = viewModel
        super.init(style: UITableView.Style.grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(for driver: Driver) {
        guard
            let imageRow       = form.rowBy(tag       : DriverRowName.image.rawValue) as? CircleRow,
            let nameRow        = form.rowBy(tag        : DriverRowName.name.rawValue) as? TextFloatLabelRow,
            let tlaRow         = form.rowBy(tag         : DriverRowName.tla.rawValue) as? TextFloatLabelRow,
            let dobRow         = form.rowBy(tag         : DriverRowName.dob.rawValue) as? TextFloatLabelRow,
            let ageRow         = form.rowBy(tag         : DriverRowName.age.rawValue) as? TextFloatLabelRow,
            let nationalityRow = form.rowBy(tag : DriverRowName.nationality.rawValue) as? TextFloatLabelRow,
            let moreInfoRow    = form.rowBy(tag    : DriverRowName.moreInfo.rawValue) as? TextFloatLabelRow
            else { return }
        
        title = driver.familyName
        
        imageRow.labelText = driver.initials
        
        nameRow.value = driver.fullName
        tlaRow.value = driver.code
        dobRow.value = driver.stringDateOfBirth
        ageRow.value = "TBC"
        nationalityRow.value = driver.nationality
        moreInfoRow.value = driver.stringUrl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        form = Form(
            Section()
                <<< CircleRow(DriverRowName.image.rawValue)
                
                +++ Section()
                <<< TextFloatLabelRow(DriverRowName.name.rawValue) { row in
                    row.title = "Full Name"
                    row.disabled = true
                }
                <<< TextFloatLabelRow(DriverRowName.tla.rawValue) { row in
                    row.title = "TLA"
                    row.disabled = true
                }
                <<< TextFloatLabelRow(DriverRowName.dob.rawValue) { row in
                    row.title = "Date of Birth"
                    row.disabled = true
                }
                <<< TextFloatLabelRow(DriverRowName.age.rawValue) { row in
                    row.title = "Age"
                    row.disabled = true
                }
                <<< TextFloatLabelRow(DriverRowName.nationality.rawValue) { row in
                    row.title = "Nationality"
                    row.disabled = true
                }
                <<< TextFloatLabelRow(DriverRowName.moreInfo.rawValue) { row in
                    row.title = "More Info"
                    row.disabled = true
                    row.onCellSelection({ [unowned self] (cell, row) in
                        self.viewModel.selectedUrl()
                    })
            })
        
        viewModel.observableDriver
            .subscribe(onNext: { [unowned self] (driver) in
                self.setupView(for: driver)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
    }
    
}
