//
//  TableViewController.swift
//  ToDoList
//
//  Created by Sergey on 03.05.2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var toDoItems: [Task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllItems()
    }
    
    @IBAction func deleteTasks(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        
        do {
            try context.save()
            print("deleted")
        } catch {
            print(error.localizedDescription)
        }
        self.toDoItems.removeAll(keepingCapacity: false)
        tableView.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {
        let alert = UIAlertController(title: "Add Task", message: "add new task", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            let textField = alert.textFields?.first?.text // first not working??
            if let newTask = textField {
                self.saveTask(taskToDo: newTask)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { _ in
            
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTask(taskToDo: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        taskObject.taskToDo = taskToDo
        
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllItems() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            try context.save()
            toDoItems = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(item: Task, newName: String) {
        item.taskToDo = newName
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
        }
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            
            let task = self.toDoItems[indexPath.row]
            
            self.toDoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(task)
            
            do {
                try context.save()
            } catch let deleteErr {
                print("Failed to delete task", deleteErr)
            }
            
            completionHandler(true)
        }
        delete.backgroundColor = .red
        return delete
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let task = self.toDoItems[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let edit = UIAlertController(title: "Edit Task", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in

                let textField = edit.textFields?.first?.text
                if let editTask = textField {
                    self.updateItem(item: task, newName: editTask)
                    self.tableView.reloadData()
                }
            }
        
            edit.addTextField { _ in

            }
            edit.addAction(okAction)
            edit.addAction(cancelAction)
            self.present(edit, animated: true, completion: nil)
            
            print("edit")
        }
        
        editAction.backgroundColor = .gray
        return editAction
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
        
        let task = toDoItems[indexPath.row]
        cell.textLabel?.text = task.taskToDo
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let editItem = editAction(at: indexPath)
        
        let swipeAction = UISwipeActionsConfiguration(actions: [delete, editItem])
        return swipeAction
    
    }
}
