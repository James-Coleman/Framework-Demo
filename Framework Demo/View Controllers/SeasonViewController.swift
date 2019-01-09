//
//  SeasonViewController.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm

final class SeasonViewController: UITableViewController {
    public var viewModel: SeasonViewModel!
    private let bag = DisposeBag()
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .white
        refreshControl?.rx.controlEvent(.valueChanged).do(onNext: { (event) in
            //
        })
    }
    
    private func setBarButtonItems() {
        let button = UIBarButtonItem(image: UIImage(named: "Settings Cog"), style: .plain, target: self, action: #selector(tappedBarButton))
        
/*
        let buttonNew = UIButton(frame: CGRect(x: 360, y: 12, width: 24, height: 24))
        buttonNew.setImage(UIImage(named: "Settings Cog"), for: .normal)
        buttonNew.addTarget(self, action: #selector(tappedBarButton), for: .touchUpInside)
        view.addSubview(buttonNew)
//        navigationController?.navigationBar.addSubview(buttonNew)
        
        let button2 = UIBarButtonItem(customView: buttonNew)
        button2.customView?.hero.id = "button2"
//        button2.customView?.hero.modifiers = [.rotate(CGFloat(2 * Double.pi))]
*/
        
        navigationItem.setRightBarButtonItems([button], animated: false)
    }
    
    @objc
    private func tappedBarButton() {
        UIView.animate(withDuration: 1) { [unowned self] in
            self.navigationItem.rightBarButtonItem?.customView?.transform = .init(rotationAngle: CGFloat(Double.pi))
        }
        
        viewModel.tappedBarButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupRefreshControl() // Commented out while refresh does not do anything.
        
        setBarButtonItems()
        
        viewModel.title
            .bind(to: rx.title)
            .disposed(by: bag)
        
        let reuseIdentifier = "cell"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let dataSource = RxTableViewRealmDataSource<Race>(cellIdentifier: reuseIdentifier, cellType: UITableViewCell.self) { (cell, indexPath, race) in
            
            cell.textLabel?.text = "\(race.round) - \(race.raceName)"
            
            cell.detailTextLabel?.text = "\(race.time) \(race.date)"
            
            cell.accessoryType = .disclosureIndicator
            
//            cell.selectionStyle = .none
        }
        
        let tableData = viewModel.tableViewData
            .share()
        
        tableData
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
        tableData.map { (results, changes) -> String in
            guard results.count > 0 else { return "Current Season" }
            return "\(results[0].season) Season"
            }
            .bind(to: rx.title)
            .disposed(by: bag)
        
        tableView.rx.realmModelSelected(Race.self)
            .bind { race in
                self.viewModel.selected(race)
            }
            .disposed(by: bag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hero.isEnabled = false
    }
}
