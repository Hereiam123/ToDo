//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/20/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<CategoryItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load categories on start
        loadCategories()
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
        categoryArray = realm.objects(CategoryItem.self)
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
        return categoryArray?.count ?? 1
    }
    
    //Mark - TableView Cell Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for:indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"

        return cell
    }
    
    //Mark - TableView Category Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
