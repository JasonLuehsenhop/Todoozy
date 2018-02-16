//
//  ViewController.swift
//  Todoozy
//
//  Created by Jason Luehsenhop on 2/9/18.
//  Copyright © 2018 Jason Luehsenhop. All rights reserved.
//

import UIKit
import CoreData

class TodoListController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        loadItems()
        
        
    }

    
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//
//        }
        
        return cell
    }
    
    
    
    
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoozy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textField = alertTextField
            
         }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        
        do {
            
          try context.save()
            
        } catch {
            print("Error saving context \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
    
    func loadItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
        try itemArray = context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    
    }
    
    
    

}

