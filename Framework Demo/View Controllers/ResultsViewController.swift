//
//  ResultsViewController.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift

final class ResultsViewController: UITableViewController {
    public var viewModel: ResultsViewModel!
    public var race: Race!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(race.season) Round \(race.round)"
        
        let reuseIdentifier = "cell"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let dataSource = RxTableViewRealmDataSource<Result>(cellIdentifier: reuseIdentifier, cellType: UITableViewCell.self) { (cell, indexPath, result) in
            
            cell.textLabel?.text = "\(result.positionText) - \(result.number) - \(result.laps)"
            
            cell.accessoryType = .disclosureIndicator
        }
        
        let tableData = Observable.changeset(from: viewModel.tableViewData(race: race))
            .share()
        
        tableData
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
        tableView.rx.realmModelSelected(Result.self)
            .bind { result in
                self.viewModel.selected(result)
            }
            .disposed(by: bag)
    }
}
