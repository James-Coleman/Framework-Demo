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
    public var result: Result
    
    init(result: Result) {
        self.result = result
    }
}

extension DriverViewModel: Stepper {
    
}
