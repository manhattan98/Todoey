//
//  ItemExtension.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 29.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    typealias AssociatedItems = (category: ItemCategory, items: [Item])
    
    
    class func select(byCategory category: ItemCategory) -> NSPredicate {
        select(byCategory: category.name!)
    }
    
    class func select(byCategory category: String) -> NSPredicate {
        NSPredicate(format: "parentCategory.name MATCHES[cd] %@", argumentArray: [category])
    }
    
    class func select(byTitle title: String) -> NSPredicate {
        NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [title])
    }
    
    class func group(itemsByCategory items: [Item]) -> [(ItemCategory, [Item])] {//[AssociatedItems] {
        var itemsDictionary = [ItemCategory : [Item]]()
                
        // group items by categories using dictionary
        items.forEach { (item) in
            var itemsInCategory = itemsDictionary[item.parentCategory!] ?? [Item]()
            itemsInCategory.append(item)
            itemsDictionary[item.parentCategory!] = itemsInCategory
        }
        
        // convert dictionary to array of touples, for order control
        var associatedItemsArray = itemsDictionary.map { (category, items) -> AssociatedItems in
            AssociatedItems(category, items)
        }
        
        // sort by category name
        associatedItemsArray.sort { (associatedItems1, associatedItems2) -> Bool in
            associatedItems1.category.name! < associatedItems2.category.name!
        }
        
        return associatedItemsArray
    }
}
