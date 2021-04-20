//
//  SearchHelper.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 29.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class SearchHelper {
    let context: NSManagedObjectContext
    
    let scopeTodoeys: SearchScope
    let scopeCategories: SearchScope
        
    // MARK: - initialization
    init(with context: NSManagedObjectContext) {
        self.context = context
        let fetchHelper = FetchHelper(using: context)
                
        self.scopeTodoeys = SearchScope(
            displayedName: "Todoeys",
            associatedObject: TodoListDataSource(with: context)) {
            let searchText = $0.searchBar.text!
            let todoeysSource = $1 as! TodoListDataSource
            let resultsController = $0.searchResultsController as! ResultsController
            
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.predicate = Item.select(byTitle: searchText)
            
            let results = Item.group(itemsByCategory: fetchHelper.fetchItems(with: fetchRequest)!)
                        
            todoeysSource.attach(to: resultsController)
            todoeysSource.applyEntities(results)
            
            return results.reduce(0, { $0.advanced(by: $1.1.count) })
        }
        
        self.scopeCategories = SearchScope(
            displayedName: "Categories",
            associatedObject: CategoryDataSource(with: context)) {
            let searchText = $0.searchBar.text!
            let categoriesSource = $1 as! CategoryDataSource
            let resultsController = $0.searchResultsController as! ResultsController
            
            let fetchRequest: NSFetchRequest<ItemCategory> = ItemCategory.fetchRequest()
            fetchRequest.predicate = ItemCategory.select(byName: searchText)
            
            let results = fetchHelper.fetchCategories(with: fetchRequest)!
                        
            categoriesSource.attach(to: resultsController)
            categoriesSource.applyEntities(results)
            
            return results.count
        }
    }
    
    
    // MARK: - main factory methods
    func getSearchController() -> UISearchController {
        return getSearchController(with: scopeCategories, scopeTodoeys)
    }
    
    func getSearchController(with scopes: SearchHelper.SearchScope...) -> UISearchController {
        let resultsController = ResultsController.newResultsController(using: context, with: scopes)
        resultsController.foundTextProvider = { "Items found: \($0)" }
        
        let searchController = UISearchController(searchResultsController: resultsController)
        
        searchController.searchResultsUpdater = resultsController
        
        if scopes.count > 1 {
            searchController.searchBar.scopeButtonTitles = scopes.map({ $0.displayedName })
        }
        
        return searchController
    }
    
    
    struct SearchScope {
        var displayedName: String
        var associatedObject: Any?
        var resultsUpdateHandler: (UISearchController, Any?) -> Int
    }
    
}
