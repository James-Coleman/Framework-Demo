//
//  Flow.swift
//  Framework Demo
//
//  Created by James Coleman on 27/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxFlow

enum AppStep: Step {
    case master
    case detail
}

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let navCon = UINavigationController()
        navCon.navigationBar.barStyle = .blackTranslucent
        navCon.navigationBar.tintColor = .orange
        return navCon
    }()
    
    init() {
        
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .master:
            return enterAtMaster()
        case .detail:
            return navigateToDetail()
        }
    }
    
    private func enterAtMaster() -> NextFlowItems {
        let masterVC = MasterVC()
        rootViewController.pushViewController(masterVC, animated: true) // Animated has no effect, probably because this is the root of the navcon, and the navcon knows that it shouldn't be animated.
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: masterVC, nextStepper: masterVC))
    }
    
    private func navigateToDetail() -> NextFlowItems {
        let detailVC = DetailVC()
        rootViewController.pushViewController(detailVC, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: detailVC, nextStepper: detailVC))
    }
}
