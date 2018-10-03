//
//  DriverViewModel.swift
//  Framework Demo
//
//  Created by James Coleman on 01/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import RxFlow

final class DriverViewModel {
    public var driver: Driver
    
    init(driver: Driver) {
        self.driver = driver
    }
}

extension DriverViewModel: Stepper {
    public func selectedUrl() {
        guard let url = driver.url else { return }
        step.accept(AppStep.website(url: url))
    }
}
