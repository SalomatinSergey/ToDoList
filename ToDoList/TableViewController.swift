//
//  TableViewController.swift
//  ToDoList
//
//  Created by Sergey on 03.05.2022.
//

import UIKit

class TableViewController: UITableViewController {

    var toDoItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "Add Task", message: "add new task", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            let textField = alert.textFields?.first
            self.toDoItems.insert((textField?.text)!, at: 0)
            self.tableView.reloadData()
        }
        
        alert.addTextField { _ in
            
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

// IOS 14 and later
//        var content = cell.defaultContentConfiguration()
//        content.text = toDoitems[indexPath.row]
        
        cell.textLabel?.text = toDoItems[indexPath.row]
        
        return cell
    }
}
