//
//  SeasonViewModel.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import RealmSwift
import RxFlow
import RxSwift

final class SeasonViewModel {
    private let seasonModelController = SeasonModelController()
    
    private let realm = try! Realm()
    
    /// The title to show on the Results View Controller
    public var title = BehaviorSubject<String>(value: "Current Season")
    
    public var tableViewData: Results<Race> {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: currentDate)
        let stringCurrentYear = String(currentYear)
        
        let races = realm.objects(Race.self)
        let currentSeasonRaces = races.filter { $0.season == stringCurrentYear }
        
        if currentSeasonRaces.count == 0 {
            seasonModelController.getCurrentSeason()
        } else {
            let newTitle = "\(currentSeasonRaces[0].season) Season"
            title.onNext(newTitle)
        }
        
        return races
    }
}

extension SeasonViewModel: Stepper {
    public func selected(_ race: Race) {
        step.accept(AppStep.results(race: race))
    }
}
