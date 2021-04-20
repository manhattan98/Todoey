//
//  EntityDataSource.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 29.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

/**
 data source for NSManagedObject entities
 */
class EntityDataSource<Entity: NSManagedObject>: NSObject, UITableViewDataSource {
    let context: NSManagedObjectContext
    
    let reusableCellId = "reusableCell"
    
    internal weak var tableView: UITableView?
    
    internal var entitiesArray: [Entity]
    
    internal let defaultCell = UITableViewCell(style: .default, reuseIdentifier: nil)
                
    //var cellForRow
    
    
    // MARK: - initialization
    init(with context: NSManagedObjectContext, attachTo tableView: UITableView? = nil) {
        self.context = context
        self.tableView = tableView
        self.entitiesArray = [Entity]()
                
        super.init()
        
        // register new generic cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellId)
        tableView?.dataSource = self
    }
    
    convenience init(with context: NSManagedObjectContext, attachTo tableViewController: UITableViewController) {
        self.init(with: context, attachTo: tableViewController.tableView)
    }
    
    
    // MARK: - configuration interface
    final func attach(to tableView: UITableView) {
        self.tableView = tableView
        
        // register new generic cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableCellId)
        
        tableView.dataSource = self

        tableView.reloadData()
    }
    
    final func attach(to tableViewController: UITableViewController) {
        attach(to: tableViewController.tableView)
    }
    
    
    // MARK: - table view data source
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView != self.tableView {
            fatalError("wtf unknown table view!")
        }
        
        return internalNumberOfRows(in: section)
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView != self.tableView {
            fatalError("wtf unknown table view!")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellId, for: indexPath)
        let entity = getEntity(at: indexPath)
        
        entityDataSource(prepareCell: cell, for: entity)
        
        return cell
        
    }
    
    final func numberOfSections(in tableView: UITableView) -> Int {
        if tableView != self.tableView {
            fatalError("wtf unknown table view!")
        }
        
        return internalNumberOfSections()
    }
    
    final func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView != self.tableView {
            fatalError("wtf unknown table view!")
        }
        
        return internalTitleForHeader(in: section)
    }
    
    
    // MARK: - methods that sublcasses may override
    func entityDataSource(prepareCell cell: UITableViewCell, for entity: Entity) {
        cell.accessoryType = defaultCell.accessoryType
        cell.accessoryView = defaultCell.accessoryView
        cell.backgroundView = defaultCell.backgroundView
        cell.selectedBackgroundView = defaultCell.selectedBackgroundView
        if #available(iOS 14.0, *) {
            cell.backgroundConfiguration = defaultCell.backgroundConfiguration
            cell.contentConfiguration = defaultCell.contentConfiguration
            cell.automaticallyUpdatesContentConfiguration = defaultCell.automaticallyUpdatesContentConfiguration
            cell.automaticallyUpdatesBackgroundConfiguration = defaultCell.automaticallyUpdatesBackgroundConfiguration
        }
        cell.multipleSelectionBackgroundView = defaultCell.multipleSelectionBackgroundView
        cell.textLabel?.text = defaultCell.textLabel?.text
        
        // subclasses can override this method to configure cell for entity
    }

    
    // MARK: - internal methods that encapsulate data structure
    internal func internalInsertRow(_ newEntity: Entity) -> IndexPath {
        entitiesArray.append(newEntity)
        
        return IndexPath(row: self.entitiesArray.count - 1, section: 0)
    }
    
    internal func internalRemoveRow(_ row: Int, in section: Int) -> Entity {
        return entitiesArray.remove(at: row)
    }
    
    internal func internalNumberOfSections() -> Int {
        return 1
    }
    
    internal func internalNumberOfRows(in section: Int) -> Int {
        return entitiesArray.count
    }
    
    internal func internalTitleForHeader(in section: Int) -> String? {
        return nil
    }
    
    internal func internalGetEntity(_ row: Int, in section: Int) -> Entity {
        return entitiesArray[row]
    }
    
    
    // MARK: - data manipulation methods
    final func commitChanges() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func applyEntities(_ entities: [Entity]) {
        self.entitiesArray = entities
        
        applyEntities()
    }
    
    func applyEntities() {
        tableView?.reloadData()
        tableView?.reloadSections(IndexSet(integersIn: 0..<internalNumberOfSections()), with: .none)
    }

    final func deleteEntity(at indexPath: IndexPath) {
        var entityToDelete: Entity!
        
        entityToDelete = internalRemoveRow(indexPath.row, in: indexPath.section)
        
        if let realTableView = tableView {
            realTableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            print("table view not present!")
        }
        context.delete(entityToDelete)
    }
    
    final func addNewEntity(initializationBlock: (Entity) -> Void) {
        let newEntity = Entity(context: context)
        
        initializationBlock(newEntity)
                
        tableView?.insertRows(at: [internalInsertRow(newEntity)], with: .automatic)
    }
    
    final func getEntity(at indexPath: IndexPath) -> Entity {
        return internalGetEntity(indexPath.row, in: indexPath.section)
    }
}
