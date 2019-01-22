//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/20/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let realm = try! Realm()
    
    var categoryItems: Results<CategoryItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load categories on start
        loadCategories()
        
        tableView.rowHeight = 100
    }

    //Mark - Save Categories
    func saveCategories(category: CategoryItem){
        do{
            try realm.write{
                realm.add(category)
            }
        }
        catch{
            print("Error saving item array in context \(error)")
        }
    }
    
    //Mark - Load Categories
    func loadCategories(){
        categoryItems = realm.objects(CategoryItem.self)
        tableView.reloadData()
    }
    
    //Mark - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Category"
            addItemTextField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //What happens when user clicks add category button on UI alert
            let newCategory = CategoryItem()
            
            newCategory.name = addItemTextField.text!
            
            self.saveCategories(category: newCategory)
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - TableView Cell Row Count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    
    //Mark - TableView Cell Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for:indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryItems?[indexPath.row].name ?? "No Categories Added Yet"
        cell.delegate = self
        return cell
    }
    
    //Mark - Swipe Cell Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoriesForDeletion = self.categoryItems?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoriesForDeletion)
                    }
                }
                catch{
                    print("Error deleteing category item: \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    //Mark - TableView Category Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryItems?[indexPath.row]
        }
    }
}
