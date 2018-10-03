//
//  AppDelegate.swift
//  Framework Demo
//
//  Created by James Coleman on 26/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RxFlow
import SwiftEntryKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let disposeBag = DisposeBag()
    var coordinator = Coordinator()
    lazy var appFlow: AppFlow = {
        return AppFlow()
    }()
    
    private func setupFlow() {
        guard let window = self.window else { return }
        
        Flows.whenReady(flow1: appFlow) { [unowned window] (flowroot) in
            window.rootViewController = flowroot
        }
        
        coordinator.coordinate(flow: appFlow, withStepper: OneStepper(withSingleStep: AppStep.home))
    }
    
    private func setupReachability() {
        guard let reachability = ReachabilityManager() else { return }
        reachability.reach.subscribe(onNext: { (reachable) in
            if reachable == false {
                let title = EKProperty.LabelContent(text: "Offline", style: EKProperty.LabelStyle.init(font: UIFont.systemFont(ofSize: UIFont.systemFontSize), color: .black))
                let description = EKProperty.LabelContent(text: "Functionality will be limited until online", style: EKProperty.LabelStyle.init(font: UIFont.systemFont(ofSize: UIFont.systemFontSize), color: .black))
                let message = EKSimpleMessage(title: title, description: description)
                let notification = EKNotificationMessage(simpleMessage: message)
                let content = EKNotificationMessageView(with: notification)
                
                var attributes = EKAttributes.topToast
                attributes.entryBackground = .visualEffect(style: .light)
                
                SwiftEntryKit.display(entry: content, using: attributes)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupFlow()
        setupReachability()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

