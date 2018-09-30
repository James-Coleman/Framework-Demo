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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        
        viewModel.title
            .bind(to: rx.title)
            .disposed(by: bag)
        
        let reuseIdentifier = "cell"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let dataSource = RxTableViewRealmDataSource<Race>(cellIdentifier: reuseIdentifier, cellType: UITableViewCell.self) { (cell, indexPath, race) in
            
            cell.textLabel?.text = "\(race.round) - \(race.raceName)"
            
            cell.detailTextLabel?.text = "\(race.time) \(race.date)"
            
            cell.accessoryType = .disclosureIndicator
            
            cell.selectionStyle = .none
        }
        
        let tableData = Observable.changeset(from: viewModel.tableViewData)
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
}
