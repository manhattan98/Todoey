//
//  CategoryDataSource.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 29.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryDataSource: ClickableEntityDataSource<ItemCategory> {//EntityDataSource<ItemCategory> {
    override func entityDataSource(prepareCell cell: UITableViewCell, for entity: ItemCategory) {
        super.entityDataSource(prepareCell: cell, for: entity)
        
        cell.textLabel?.text = entity.name
    }
}
