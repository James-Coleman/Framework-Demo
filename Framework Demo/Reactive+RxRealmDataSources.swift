//
//  RxRealm extensions
//
//  Copyright (c) 2016 RxSwiftCommunity. All rights reserved.
//  Check the LICENSE file for details
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa
import RxRealm
import UIKit

// MARK: - RxTableViewRealmDataSource

public typealias TableCellFactory<E: Object> = (RxTableViewRealmDataSource<E>, UITableView, IndexPath, E) -> UITableViewCell
public typealias TableCellConfig<E: Object, CellType: UITableViewCell> = (CellType, IndexPath, E) -> Void

open class RxTableViewRealmDataSource<E: Object>: NSObject, UITableViewDataSource {
    
    private var items: AnyRealmCollection<E>?
    
    // MARK: - Configuration
    
    public var tableView: UITableView?
    public var animated = true
    public var rowAnimations = (
        insert: UITableView.RowAnimation.automatic,
        update: UITableView.RowAnimation.automatic,
        delete: UITableView.RowAnimation.automatic)
    
    public var headerTitle: String?
    public var footerTitle: String?
    
    // MARK: - Init
    public let cellIdentifier: String
    public let cellFactory: TableCellFactory<E>
    
    public init(cellIdentifier: String, cellFactory: @escaping TableCellFactory<E>) {
        self.cellIdentifier = cellIdentifier
        self.cellFactory = cellFactory
    }
    
    public init<CellType>(cellIdentifier: String, cellType: CellType.Type, cellConfig: @escaping TableCellConfig<E, CellType>) where CellType: UITableViewCell {
        self.cellIdentifier = cellIdentifier
        self.cellFactory = {ds, tv, ip, model in
            let cell = tv.dequeueReusableCell(withIdentifier: cellIdentifier, for: ip) as! CellType
            cellConfig(cell, ip, model)
            return cell
        }
    }
    
    // MARK: - Data access
    public func model(at indexPath: IndexPath) -> E {
        return items![indexPath.row]
    }
    
    // MARK: - UITableViewDataSource protocol
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(self, tableView, indexPath, items![indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitle
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitle
    }
    
    // MARK: - Applying changeset to the table view
    private let fromRow = {(row: Int) in return IndexPath(row: row, section: 0)}
    
    func applyChanges(items: AnyRealmCollection<E>, changes: RealmChangeset?) {
        if self.items == nil {
            self.items = items
        }
        
        guard let tableView = tableView else {
            fatalError("You have to bind a table view to the data source.")
        }
        
        guard animated else {
            tableView.reloadData()
            return
        }
        
        guard let changes = changes else {
            tableView.reloadData()
            return
        }
        
        let lastItemCount = tableView.numberOfRows(inSection: 0)
        guard items.count == lastItemCount + changes.inserted.count - changes.deleted.count else {
            tableView.reloadData()
            return
        }
        
        tableView.beginUpdates()
        tableView.deleteRows(at: changes.deleted.map(fromRow), with: rowAnimations.delete)
        tableView.insertRows(at: changes.inserted.map(fromRow), with: rowAnimations.insert)
        tableView.reloadRows(at: changes.updated.map(fromRow), with: rowAnimations.update)
        tableView.endUpdates()
    }
}

// MARK: - RxCollectionViewRealmDataSource

public typealias CollectionCellFactory<E: Object> = (RxCollectionViewRealmDataSource<E>, UICollectionView, IndexPath, E) -> UICollectionViewCell
public typealias CollectionCellConfig<E: Object, CellType: UICollectionViewCell> = (CellType, IndexPath, E) -> Void

open class RxCollectionViewRealmDataSource <E: Object>: NSObject, UICollectionViewDataSource {
    private var items: AnyRealmCollection<E>?
    
    // MARK: - Configuration
    
    public var collectionView: UICollectionView?
    public var animated = true
    
    // MARK: - Init
    public let cellIdentifier: String
    public let cellFactory: CollectionCellFactory<E>
    
    public init(cellIdentifier: String, cellFactory: @escaping CollectionCellFactory<E>) {
        self.cellIdentifier = cellIdentifier
        self.cellFactory = cellFactory
    }
    
    public init<CellType>(cellIdentifier: String, cellType: CellType.Type, cellConfig: @escaping CollectionCellConfig<E, CellType>) where CellType: UICollectionViewCell {
        self.cellIdentifier = cellIdentifier
        self.cellFactory = {ds, cv, ip, model in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: ip) as! CellType
            cellConfig(cell, ip, model)
            return cell
        }
    }
    
    // MARK: - Data access
    public func model(at indexPath: IndexPath) -> E {
        return items![indexPath.row]
    }
    
    // MARK: - UICollectionViewDataSource protocol
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellFactory(self, collectionView, indexPath, items![indexPath.row])
    }
    
    // MARK: - Applying changeset to the collection view
    private let fromRow = {(row: Int) in return IndexPath(row: row, section: 0)}
    
    func applyChanges(items: AnyRealmCollection<E>, changes: RealmChangeset?) {
        if self.items == nil {
            self.items = items
        }
        
        guard let collectionView = collectionView else {
            fatalError("You have to bind a collection view to the data source.")
        }
        
        guard animated else {
            collectionView.reloadData()
            return
        }
        
        guard let changes = changes else {
            collectionView.reloadData()
            return
        }
        
        let lastItemCount = collectionView.numberOfItems(inSection: 0)
        guard items.count == lastItemCount + changes.inserted.count - changes.deleted.count else {
            collectionView.reloadData()
            return
        }
        
        collectionView.performBatchUpdates({[unowned self] in
            collectionView.deleteItems(at: changes.deleted.map(self.fromRow))
            collectionView.reloadItems(at: changes.updated.map(self.fromRow))
            collectionView.insertItems(at: changes.inserted.map(self.fromRow))
            }, completion: nil)
    }
}

// MARK: - RealmBindObserver

public class RealmBindObserver<O: Object, C: RealmCollection, DS>: ObserverType {
    typealias BindingType = (DS, C, RealmChangeset?) -> Void
    public typealias E = (C, RealmChangeset?)
    
    let dataSource: DS
    let binding: BindingType
    
    init(dataSource: DS, binding: @escaping BindingType) {
        self.dataSource = dataSource
        self.binding = binding
    }
    
    public func on(_ event: Event<E>) {
        switch event {
        case .next(let element):
            binding(dataSource, element.0, element.1)
        case .error:
            return
        case .completed:
            return
        }
    }
    
    func asObserver() -> AnyObserver<E> {
        return AnyObserver(eventHandler: on)
    }
}

// MARK: - Reactive+RxRealmDataSources

extension Reactive where Base: UITableView {
    
    public func realmChanges<E>(_ dataSource: RxTableViewRealmDataSource<E>)
        -> RealmBindObserver<E, AnyRealmCollection<E>, RxTableViewRealmDataSource<E>> {
            
            return RealmBindObserver(dataSource: dataSource) {ds, results, changes in
                if ds.tableView == nil {
                    ds.tableView = self.base
                }
                ds.tableView?.dataSource = ds
                ds.applyChanges(items: AnyRealmCollection<E>(results), changes: changes)
            }
    }
    
    public func realmModelSelected<E>(_ modelType: E.Type) -> ControlEvent<E> where E: RealmSwift.Object {
        
        let source: Observable<E> = self.itemSelected.flatMap { [weak view = self.base as UITableView] indexPath -> Observable<E> in
            guard let view = view, let ds = view.dataSource as? RxTableViewRealmDataSource<E> else {
                return Observable.empty()
            }
            
            return Observable.just(ds.model(at: indexPath))
        }
        
        return ControlEvent(events: source)
    }
    
}

extension Reactive where Base: UICollectionView {
    
    public func realmChanges<E>(_ dataSource: RxCollectionViewRealmDataSource<E>)
        -> RealmBindObserver<E, AnyRealmCollection<E>, RxCollectionViewRealmDataSource<E>> {
            
            return RealmBindObserver(dataSource: dataSource) {ds, results, changes in
                if ds.collectionView == nil {
                    ds.collectionView = self.base
                }
                ds.collectionView?.dataSource = ds
                ds.applyChanges(items: AnyRealmCollection<E>(results), changes: changes)
            }
    }
    
    public func realmModelSelected<E>(_ modelType: E.Type) -> ControlEvent<E> where E: RealmSwift.Object {
        
        let source: Observable<E> = self.itemSelected.flatMap { [weak view = self.base as UICollectionView] indexPath -> Observable<E> in
            guard let view = view, let ds = view.dataSource as? RxCollectionViewRealmDataSource<E> else {
                return Observable.empty()
            }
            
            return Observable.just(ds.model(at: indexPath))
        }
        
        return ControlEvent(events: source)
    }
}
