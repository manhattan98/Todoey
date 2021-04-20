//
//  ResultsController.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 29.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ResultsController: UITableViewController, UISearchResultsUpdating {
    internal var context: NSManagedObjectContext!
    
    internal var fetchHelper: FetchHelper!
    
    internal var searchScopes: [SearchHelper.SearchScope]!
    
    
    @IBOutlet weak var itemsFoundLabel: UILabel!
    

    // MARK: - factory methods
    class func newResultsController(using context: NSManagedObjectContext, with scopes: [SearchHelper.SearchScope]) -> ResultsController {
        let resultsController = UIStoryboard(name: K.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: "ResultsController") as! ResultsController
        
        resultsController.searchScopes = scopes
        
        return resultsController
    }
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    // MARK: - configuration interface
    var foundTextProvider = { (count: Int) in "Found: \(count)" } {
        didSet {
            itemsFound = { itemsFound }()
        }
    }
    
    var itemsFound = 0 {
        willSet {
            if isViewLoaded {
                itemsFoundLabel.text = foundTextProvider(newValue)
            }
        }
    }
    
    
    // MARK: - table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    // MARK: - updating search results
    func updateSearchResults(for searchController: UISearchController) {
        let selectedCategory = searchScopes[searchController.searchBar.selectedScopeButtonIndex]
        
        itemsFound = selectedCategory.resultsUpdateHandler(searchController, selectedCategory.associatedObject)
    }

    
    // MARK: - navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
