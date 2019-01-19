//
//  ViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/18/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Eat Apples","Eat Fish","Throw Away Car"]
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            self.itemArray = items
        }
    }
    
    //Mark - Create Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //Mark - TableView Cell Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
              tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
              tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(addItemTextField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

