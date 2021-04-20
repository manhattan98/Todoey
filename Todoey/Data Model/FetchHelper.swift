//
//  FetchHelper.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 27.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreData

class FetchHelper {
    let context: NSManagedObjectContext
    
    init(using context: NSManagedObjectContext) {
        self.context = context
    }
    
    /*func findMatches() -> NSPredicate {
        
    }*/
    
    func fetchItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), for category: ItemCategory? = nil) -> [Item]? {
        // logical AND category predicate, if category isn't nil
        if let categoryName = category?.name {
            let parentPredicate = Item.select(byCategory: categoryName)
            
            if let existingPredicate = request.predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                    existingPredicate,
                    parentPredicate
                ])
            } else {
                request.predicate = parentPredicate
            }
        }
        
        return try? context.fetch(request)
    }
    
    func fetchCategories(with request: NSFetchRequest<ItemCategory> = ItemCategory.fetchRequest()) -> [ItemCategory]? {
        return try? context.fetch(request)
    }
}
