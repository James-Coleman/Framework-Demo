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
import RxRealm

final class SeasonViewModel {
    private let seasonModelController = SeasonModelController()
    
    private let realm = try! Realm()
    private let bag = DisposeBag()
    
    /// The title to show on the Results View Controller
    public var title = BehaviorSubject<String>(value: "Current Season")
    
    public var tableViewData: Observable<(AnyRealmCollection<Race>, RealmChangeset?)>!
    
    init() {
        // This was used to calculate the current season expected to be displayed, but when it returned 2019 before the 2019 season had started, this resulted in no races being shown and an error occured. The current season identified as 2018 and would be downloaded every time upon launch, which created conflicts with the unique ids.
        /*
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: currentDate)
        let stringCurrentYear = String(currentYear)
        */
        
        let races = realm.objects(Race.self)
//        let currentSeasonRaces = races.filter("season == %@", stringCurrentYear)
        let races2018 = races.filter("season == '2018'")
        let observableRaces = Observable.changeset(from: races2018)
        
        if races2018.count == 0 {
            seasonModelController.get2018Season()
        }
        
        tableViewData = observableRaces
        
        observableRaces.share()
            .map { (results, changes) -> String in
                guard results.count > 0 else { return "Current Season" }
                return "\(results[0].season) Season"
        }
        .bind(to: title)
        .disposed(by: bag)
    }
}

extension SeasonViewModel: Stepper {
    public func selected(_ race: Race) {
        step.accept(AppStep.results(race: race))
    }
    
    public func tappedBarButton() {
        step.accept(AppStep.settings)
    }
}
