//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    private var hasSearchController = Bool(true)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataSource: TodoListDataSource!
    
    var fetchHelper: FetchHelper!
    
    var category: ItemCategory? {
        willSet {
            if isViewLoaded {
                dataSource.applyEntities(fetchHelper.fetchItems(for: newValue)!)
            }
        }
    }
        
    
    // MARK: - initialization
    class func newTodoListViewController(forCategory category: ItemCategory?, hasSearchController: Bool = true) -> TodoListViewController {
        let mainStoryboard = UIStoryboard(name: K.mainStoryboard, bundle: nil)
        
        let todoListVC = mainStoryboard.instantiateViewController(identifier: "TodoListViewController") as! TodoListViewController
        
        todoListVC.category = category
        todoListVC.hasSearchController = hasSearchController
        
        return todoListVC
    }
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSource = TodoListDataSource(with: context, attachTo: self)
        
        fetchHelper = FetchHelper(using: context)
        
        // initial fetch
        dataSource.applyEntities(fetchHelper.fetchItems(for: category)!)
        
        // setup search controller
        if hasSearchController {
            let searchHelper = SearchHelper(with: context)
            // search within selected category
            navigationItem.searchController = searchHelper.getSearchController(with: SearchHelper.SearchScope(
                displayedName: "Todoeys",
                associatedObject: TodoListDataSource(with: context)) {
                let todoeysSource = $1 as! TodoListDataSource
                let resultsController = $0.searchResultsController as! UITableViewController
                
                let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
                fetchRequest.predicate = Item.select(byTitle: $0.searchBar.text!)
                
                let results = self.fetchHelper.fetchItems(with: fetchRequest, for: self.category)!
                                
                todoeysSource.attach(to: resultsController)
                todoeysSource.applyEntities(results)
                
                return results.count
            })//searchHelper.scopeTodoeys)
        }
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
                
        tableView.rowHeight = CGFloat(K.rowHeight)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigationController?.navigationBar.tintColor = .white
        //navigationItem.backButtonTitle = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dataSource.commitChanges()
    }
    
    
    // MARK: - misc ui utils
    func checkCellForRow(_ isCheck: Bool, at indexPath: IndexPath) {
        //tableView.cellForRow(at: indexPath)!.accessoryType = isCheck ? .checkmark : .none
        checkCell(isCheck, cell: tableView.cellForRow(at: indexPath)!)
    }
    
    func checkCell(_ isCheck: Bool, cell: UITableViewCell) {
        cell.accessoryType = isCheck ? .checkmark : .none
    }
    
    
    // MARK: - check-uncheck functionality
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.getEntity(at: indexPath)
        
        item.done.toggle()
        dataSource.commitChanges()
        
        checkCellForRow(item.done, at: indexPath)
        
        print("row at index \(indexPath.row) did selected!")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - swipe functionality
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.dataSource.deleteEntity(at: indexPath)
            
            self.dataSource.commitChanges()

            completionHandler(true)
            
        }
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return actions
    }
    
    
    // MARK: - add new items functionlity
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "And here is a message", preferredStyle: .alert)
        
        unowned var myTextField: UITextField!
        
        alert.addTextField { (textField) in
            print("new textField is initializing")
            
            textField.placeholder = "Create new item"
            
            myTextField = textField
        }
                
        alert.addAction(UIAlertAction(title: "Add Item", style: .default) { (addAction) in
            if let text = myTextField.text, !text.isEmpty {
                self.dataSource.addNewEntity { (item) in
                    item.done = false
                    item.title = text
                    item.parentCategory = self.category
                }
                
                self.dataSource.commitChanges()
                
                print("add action completed successfully")
            } else {
                print("add action completed with no new item")
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true) {
            print("alert completed")
        }
    }
}


// MARK: - search logic
extension TodoListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title contains[cd] %@", argumentArray: [searchText])
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }
    }
}
