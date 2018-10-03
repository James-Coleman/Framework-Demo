//
//  ResultsViewModel.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import RealmSwift
import RxFlow

final class ResultsViewModel {
    private let resultsModelController = ResultsModelController()
    
    private let realm = try! Realm()
    
    public func tableViewData(race: Race) -> Results<Result> {
        
        let results = realm.objects(Result.self)
        
        // https://stackoverflow.com/questions/39048337/filtering-linkingobjects-of-a-linkingobject-in-a-predicate-in-realmswift
        let predicate = NSPredicate(format: "ANY race.season == %@ AND ANY race.round == %@", race.season, race.round)
        
        let desiredResults = results.filter(predicate)
        
        print(results.count, desiredResults.count)
        
        if desiredResults.count == 0 {
            resultsModelController.get(year: race.season, round: race.round)
        }
        
        return desiredResults
    }
}

extension ResultsViewModel: Stepper {
    public func selected(_ result: Result) {
        guard let driver = result.driver else { return }
        step.accept(AppStep.driver(driver: driver))
    }
}
