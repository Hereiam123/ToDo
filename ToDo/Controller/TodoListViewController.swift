//
//  ViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/18/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController, UISearchBarDelegate {

    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemList : Results<Item>?
    
    var selectedCategory : CategoryItem? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.backgroundColor else { fatalError() }
        updateNavbar(withHexCode: colorHex)
        title = selectedCategory!.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavbar(withHexCode: "1D9BF6")
    }
    
    //Mark - Navbar Setup Methods
    func updateNavbar(withHexCode hexCode: String){
        guard let navbar = navigationController?.navigationBar else {fatalError("Nav Controller not here!")}
        guard let navBarColor = UIColor(hexString: hexCode) else {fatalError()}
        navbar.barTintColor = navBarColor
        navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    
    }
    
    //Mark - Create Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    //Mark - Table Row Setup
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemList?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage:
                //Darken each background color based on index path
                CGFloat(indexPath.row) / CGFloat(itemList!.count)
                ){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items Added Yet"
        }
        return cell
    }
    
    //Mark - TableView Cell Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemList?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }
            catch{
                print("Realm item select write error: \(error)")
            }
        }
        
        tableView.reloadData()
        
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
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = addItemTextField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error saving item array in context \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //Mark - Load Items
    func loadItems(){
        itemList = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //Mark - Delete Item on Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.itemList?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            }
            catch{
                print("Error deleteing ToDo item: \(error)")
            }
        }
    }
    
    //Mark - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemList = itemList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

