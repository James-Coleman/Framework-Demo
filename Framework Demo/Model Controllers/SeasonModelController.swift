//
//  SeasonModelController.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Moya

struct SeasonModelController {
    private let bag = DisposeBag()
    private let realm = try! Realm()
    
    private let provider = MoyaProvider<ErgastAPI>(
        plugins: [NetworkLoggerPlugin(verbose: false)] // Verbose logging includes the full response. Otherwise logging just includes the headers.
    )
    
    public func getCurrentSeason() {
        let observableCurrentSeason = provider.rx.request(.getCurrentSeason)
            .map(ErgastResponse.self)
            .asObservable()
        
        observableCurrentSeason
            .subscribe(realm.rx.add())
            .disposed(by: bag)
    }
}
