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
import RxRealm

final class DriverViewModel {
    private var driver: Driver
    private let driverModelController = DriverModelController()
    
    public var observableDriver: Observable<Driver>
    
    init(driver: Driver) {
        self.driver = driver
        self.observableDriver = Observable.from(object: driver)
        
        if driver.imgUrl == "" {
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
