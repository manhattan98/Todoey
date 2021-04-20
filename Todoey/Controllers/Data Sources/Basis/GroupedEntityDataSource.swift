//
//  ooo.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 30.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

/**
 entity data source dubclass that support multi section grouped entities list
 */
class GroupedEntityDataSource<Group: NSManagedObject, Entity: NSManagedObject>: EntityDataSource<Entity> {
    typealias AssociatedEntities = (section: Group?, rows: [Entity])

    
    internal var groupedEntities: [AssociatedEntities]
    
    
    // MARK: - initialization
    override init(with context: NSManagedObjectContext, attachTo tableView: UITableView? = nil) {
        self.groupedEntities = [AssociatedEntities]()
        
        super.init(with: context, attachTo: tableView)
    }
    
    
    // MARK: - overrides
    override func internalInsertRow(_ newEntity: Entity) -> IndexPath {
        let sectionToAdd = groupedEntities.count - 1

        groupedEntities[sectionToAdd].rows.append(newEntity)
        
        return IndexPath(row: self.groupedEntities[sectionToAdd].rows.count - 1, section: sectionToAdd)
    }
    
    override func internalRemoveRow(_ row: Int, in section: Int) -> Entity {
        return groupedEntities[section].rows.remove(at: row)
    }
    
    override func internalNumberOfSections() -> Int {
        return groupedEntities.count
    }
    
    override func internalNumberOfRows(in section: Int) -> Int {
        return groupedEntities[section].rows.count
    }
    
    override func internalTitleForHeader(in section: Int) -> String? {
        return groupedEntities[section].section == nil ? nil : groupedEntityDataSource(headerTitleForGroup: groupedEntities[section].section!)
    }
    
    override func internalGetEntity(_ row: Int, in section: Int) -> Entity {
        return groupedEntities[section].rows[row]
    }
    
    override func applyEntities(_ entities: [Entity]) {
        applyEntities([AssociatedEntities(nil, entities)])
    }
    
    func applyEntities(_ entities: [AssociatedEntities]) {
        groupedEntities = entities
        
        applyEntities()
    }
    
    
    // MARK: - methods that sublcasses must override
    func groupedEntityDataSource(headerTitleForGroup group: Group) -> String? {
        fatalError("method groupedEntityDataSource(headerTitleForGroup:) must be implemented")
    }
    
}
