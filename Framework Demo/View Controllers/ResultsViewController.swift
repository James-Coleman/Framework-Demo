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
    
    private lazy var emptyPlaceholder: UILabel = {
        let label = UILabel(frame: tableView.frame)
        label.textAlignment = .center
        label.text = "This race is due to happen \(race.date)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(race.season) Round \(race.round)"
        
        let reuseIdentifier = "cell"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let dataSource = RxTableViewRealmDataSource<Result>(cellIdentifier: reuseIdentifier, cellType: UITableViewCell.self) { (cell, indexPath, result) in
            
            cell.textLabel?.text = "\(result.positionText). \(result.driver?.code ?? result.number) - \(result.laps) laps"
            
            cell.accessoryType = .disclosureIndicator
        }
        
        let tableData = Observable.changeset(from: viewModel.tableViewData(race: race))
//            .share()
        
        tableData
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
        tableData
            .subscribe(onNext: { [unowned self] (results, changes) in
                if results.isEmpty {
                    self.tableView.backgroundView = self.emptyPlaceholder
                    self.tableView.separatorStyle = .none
                    self.tableView.isScrollEnabled = false
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.isScrollEnabled = true
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)
        
        tableView.rx.realmModelSelected(Result.self)
            .bind { result in
                self.viewModel.selected(result)
            }
            .disposed(by: bag)
    }
}
