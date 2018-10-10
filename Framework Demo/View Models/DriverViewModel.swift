//
//  DriverViewModel.swift
//  Framework Demo
//
//  Created by James Coleman on 01/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RealmSwift
import RxRealm

final class DriverViewModel {
    private var driver: Driver
    private let driverModelController = DriverModelController()
    private let realm = try! Realm()
    
    public var observableDriver     : Observable<Driver>
//    public var observableDriverImage: Observable<DriverImage>
    
    init(driver: Driver) {
        self.driver = driver
        self.observableDriver = Observable.from(object: driver)
        
        if driver.imageLoaded == false {
            try? driverModelController.getImage(driver: driver)
        }
    }
}

extension DriverViewModel: Stepper {
    public func selectedUrl() {
        guard let url = driver.url else { return }
        step.accept(AppStep.website(url: url))
    }
}
