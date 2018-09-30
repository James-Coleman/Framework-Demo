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
    case results(race: Race)
    case news(item: Int)
    case settings
}

class ResultsFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let seasonViewModel: SeasonViewModel
    
    private lazy var rootViewController: UINavigationController = {
        let navCon = AppNavCon()
        
        let seasonVC = SeasonViewController()
        seasonVC.viewModel = seasonViewModel
        seasonVC.tabBarItem = UITabBarItem(title: "Results", image: nil, selectedImage: nil)
        navCon.pushViewController(seasonVC, animated: false)
        
        return navCon
    }()
    
    init(with seasonViewModel: SeasonViewModel) {
        self.seasonViewModel = seasonViewModel
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        /*
        case .home:
            return navigateToSeason()
        */
        case .results(let race):
            return navigateToResults(of: race)
        default:
            return .none
        }
    }
    
    /*
    private func navigateToSeason() -> NextFlowItems {
        return .one(flowItem: NextFlowItem(nextPresentable: seasonVC, nextStepper: seasonViewModel))
    }
    */
    
    private func navigateToResults(of race: Race) -> NextFlowItems {
        let resultsVC = ResultsViewController()
        resultsVC.race = race
        resultsVC.viewModel = ResultsViewModel()
        rootViewController.pushViewController(resultsVC, animated: true)
        
        return .none // At the moment, this cannot navigate anywhere
    }
    
}

class NewsFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    lazy var rootViewController: UINavigationController = {
        let navCon = AppNavCon()
        let tableCon = UITableViewController()
        tableCon.title = "News"
        
        navCon.setViewControllers([tableCon], animated: false)
        navCon.tabBarItem = UITabBarItem(title: "News", image: nil, selectedImage: nil)
        
        return navCon
    }()
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .news(let item):
            // Create new news item View Controller
            // Prepare news by injecting dependancies
            // Push news to the root navigation controller
            return .none
        default:
            return .none
        }
    }
}

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UITabBarController = {
        let tabBarCon = UITabBarController()
        tabBarCon.tabBar.barTintColor = .red
        tabBarCon.tabBar.tintColor = .white
        tabBarCon.tabBar.unselectedItemTintColor = .darkGray
        return tabBarCon
    }()
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .home:
            return startAtHome()
        case .settings:
            return showSettings()
        default:
            return .none
        }
    }
    
    private func startAtHome() -> NextFlowItems {
        let seasonViewModel = SeasonViewModel()
        let resultsFlow = ResultsFlow(with: seasonViewModel)
        let newsFlow = NewsFlow()
        let newsViewModel = NewsViewModel()
        
        Flows.whenReady(flow1: resultsFlow, flow2: newsFlow) { (resultsRoot, newsRoot) in
            self.rootViewController.setViewControllers([resultsRoot, newsRoot], animated: false)
        }
        
        return .multiple(flowItems: [
            NextFlowItem(nextPresentable: resultsFlow, nextStepper: seasonViewModel),
            NextFlowItem(nextPresentable: newsFlow, nextStepper: newsViewModel)
            ])
    }
    
    private func showSettings() -> NextFlowItems {
        return .none
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
