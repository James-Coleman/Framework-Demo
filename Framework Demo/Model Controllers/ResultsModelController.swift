//
//  ResultsModelController.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Moya
import RxMoya

struct ResultsModelController {
    private let bag = DisposeBag()
    private let realm = try! Realm()
    
    private let provider = MoyaProvider<ErgastAPI>(
        plugins: [NetworkLoggerPlugin(verbose: false)] // Verbose logging includes the full response. Otherwise logging just includes the headers.
    )
    
    public func get(year: String, round: String) {
        let observableRound = provider.rx.request(.get(year: year, round: round))
            .map(ErgastResponse.self)
            .asObservable()
        
        observableRound
            .subscribe(realm.rx.add(update: true))
            .disposed(by: bag)
    }
}
