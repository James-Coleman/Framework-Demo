//
//  ResultsViewController.swift
//  Framework Demo
//
//  Created by James Coleman on 28/09/2018.
//  Copyright © 2018 James Coleman. All rights reserved.
//

import UIKit
import RxSwift
import Hero

final class ResultsViewController: UITableViewController {
    public var viewModel: ResultsViewModel!
    public var race: Race!
    
    private let bag = DisposeBag()
    
    private lazy var dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
    
    private lazy var emptyPlaceholder: UILabel = {
        let label = UILabel(frame: tableView.frame)
        label.textAlignment = .center
        
        var labelText: String {
            if let dateString = try? dateFormatter.appStringDate(from: race.date) {
                return "This race is due to happen on \(dateString)"
            } else {
                return "This race is due to happen in the future"
            }
        }
        
        label.text = labelText
        
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
                    if let date = try? self.dateFormatter.appDate(from: self.race.date), date.isAfterNow() {
                        // If the race hasn't happened yet, show a label showing when it's due to happen
                        self.tableView.setPlaceholder(to: self.emptyPlaceholder)
                    } else {
                        // If the race is supposed to have happened, show a loading indicator
                        let activityIndicator = UIActivityIndicatorView(frame: self.tableView.frame)
                        activityIndicator.style = .gray
                        activityIndicator.startAnimating()
                        self.tableView.setPlaceholder(to: activityIndicator)
                    }
                } else {
                    self.tableView.setPlaceholder(to: nil)
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
