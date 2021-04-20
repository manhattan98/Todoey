//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 22.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataSource: CategoryDataSource!
    
    var fetchHelper: FetchHelper!
        
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = CategoryDataSource(with: context, attachTo: self)
        
        // init fetch helper
        fetchHelper = FetchHelper(using: context)
        
        // initial fetch
        dataSource.applyEntities(fetchHelper.fetchCategories()!)
        
        let searchController = SearchHelper(with: context).getSearchController()

        navigationItem.searchController = searchController
        
        tableView.rowHeight = CGFloat(K.rowHeight)
                
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationItem.title = "Todoey"
    }

    
    // MARK: - navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = dataSource.getEntity(at: indexPath)//categoriesArray[indexPath.row]
              
        navigationController?.pushViewController(TodoListViewController.newTodoListViewController(forCategory: selectedCategory), animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

    // MARK: - adding new categoty
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        
        unowned var textField: UITextField!
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (addAction) in
            if let text = textField.text, !text.isEmpty {
                self.dataSource.addNewEntity { (category) in
                    category.name = text
                }

                self.dataSource.commitChanges()
            }
        }))
        alert.addTextField { (addedTextField) in
            textField = addedTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - swipe functionality
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.dataSource.deleteEntity(at: indexPath)
            
            self.dataSource.commitChanges()

            completionHandler(true)
            
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return actions
    }
}


/*
// MARK: - search results delegate
extension CategoryViewController: SearchResultsDelegate {
    func searchResults(didSelect entity: NamedEntity, in cell: UITableViewCell) {
        if let categoryEntity = entity as? ItemCategory {
            navigationController?.pushViewController(TodoListViewController.newTodoListViewController(forCategory: categoryEntity, hasSearchController: false), animated: true)
        }
        if let itemEntity = entity as? Item {
            itemEntity.done.toggle()
            cell.accessoryType = itemEntity.done ? .checkmark : .none
        }
        
        print("clicked entity: \(entity.nameProperty)")
    }
}*/
