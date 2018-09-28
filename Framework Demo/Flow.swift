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
    case home
    case results(id: Int) // TODO: "id: Int" is a placeholder for now, change it for the actual results selected.
    case settings
}

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UITabBarController = {
        let tabBarCon = UITabBarController()
        let firstTab = UITabBarItem(title: "Results", image: nil, selectedImage: nil)
        let secondTab = UITabBarItem(title: "News", image: nil, selectedImage: nil)
        return tabBarCon
    }()
    
    init() {
        
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .home:
            return startAtHome()
        case .results(let id):
            return navigateToResults()
        case .settings:
            return showSettings()
        }
    }
    
    private func startAtHome() -> NextFlowItems {
        
    }
    
    private func navigateToResults() -> NextFlowItems {
        
    }
    
    private func showSettings() -> NextFlowItems {
        
    }
    
    
    /*
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
    */
}
