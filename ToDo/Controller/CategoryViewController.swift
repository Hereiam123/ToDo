//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/20/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [CategoryItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load categories on start
        loadCategories()
    }

    //Mark - Save Categories
    func saveCategories(){
        do{
            try context.save()
        }
        catch{
            print("Error saving item array in context \(error)")
        }
    }
    
    //Mark - Load Categories
    func loadCategories(with request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }
        catch{
            print("Error getting category request in context \(error)")
        }
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
            let newCategory = CategoryItem(context: self.context)
            
            newCategory.name = addItemTextField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - TableView Cell Row Count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Mark - TableView Cell Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for:indexPath)
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //Mark - TableView Category Selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
