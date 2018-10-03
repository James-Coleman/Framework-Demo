//
//  ReachabilityManager.swift
//  Framework Demo
//
//  Created by James Coleman on 03/10/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import Foundation
import Reachability
import RxSwift

/**
 To use:
 Create a new instance of ReachabilityManager and subscribe to the `reach` or `connection` properties.
 `reach` is a simple bool, `connection` is a ReachabilityConnection and contains more info.
 From [Artsy's Eidolon](https://github.com/artsy/eidolon/blob/24c721af3a9991c7c1ebd5dcaef80f470cf5ddcc/Kiosk/App/GlobalFunctions.swift)
 */
class ReachabilityManager {
    
    private let reachability: Reachability
    
    private let _reach = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return _reach.asObservable()
    }
    
    private let _connection = ReplaySubject<Reachability.Connection>.create(bufferSize: 1)
    var connection: Observable<Reachability.Connection> {
        return _connection.asObservable()
    }
    
    init?() {
        guard let r = Reachability() else {
            return nil
        }
        self.reachability = r
        
        do {
            try self.reachability.startNotifier()
        } catch {
            return nil
        }
        
        self._reach.onNext(self.reachability.connection != .none)
        self._connection.onNext(self.reachability.connection)
        
        self.reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self._reach.onNext(true)
                self._connection.onNext(self.reachability.connection)
            }
        }
        
        self.reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self._reach.onNext(false)
                self._connection.onNext(self.reachability.connection)
            }
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}
