//
//  ClickableEntityDataSource.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 02.04.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ClickableEntityDataSource<Entity: NSManagedObject>: EntityDataSource<Entity>, UITableViewDelegate {
    internal var selectHandler: ((UITableView, Entity) -> Void)?
    
    override init(with context: NSManagedObjectContext, attachTo tableView: UITableView? = nil) {
        super.init(with: context, attachTo: tableView)
    }
    
    init(with context: NSManagedObjectContext, attachTo tableView: UITableView? = nil, selectHandler: @escaping (UITableView, Entity) -> Void) {
        self.selectHandler = selectHandler

        super.init(with: context, attachTo: tableView)
    }
}
