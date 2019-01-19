//
//  ViewController.swift
//  ToDo
//
//  Created by Brian De Maio on 1/18/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Eat Apples","Eat Fish","Throw Away Car"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

