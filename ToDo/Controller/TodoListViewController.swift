//
//  ViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/18/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController, UISearchBarDelegate {

    let realm = try! Realm()
    
    var itemList : Results<Item>?
    
    var selectedCategory : CategoryItem? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Mark - Create Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        if let item = itemList?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
    }
    
    //Mark - TableView Cell Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        itemList[indexPath.row].done = !itemList[indexPath.row].done
//
//        saveItems()
//
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Todo Item"
            addItemTextField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What happens when user clicks add item button on UI alert
            
            let newItem = Item()
            
            newItem.title = addItemTextField.text!
            newItem.done = false

            self.saveItems(item: newItem)
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Model Save Items
    func saveItems(item: Item){
        do{
            try realm.write{
                realm.add(item)
            }
        }
        catch{
            print("Error saving item array in context \(error)")
        }
    }
    
    //Mark - Load Items
    func loadItems(){
        itemList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //Mark - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

