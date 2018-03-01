//
//  ViewController.swift
//  Todoozy
//
//  Created by Jason Luehsenhop on 2/9/18.
//  Copyright © 2018 Jason Luehsenhop. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListController: UITableViewController {
    
 
    
    var todoItems: Results<Item>?
    
    let realm = try? Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
      
    }

    
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
           
        
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Ternary operator ==>
            //value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Found"
        }
        
        return cell
    }
    
    
    
    
    
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm?.write {
//                    realm?.delete(item)
                    item.done = !item.done
                }
                } catch {
                    print("Error saving done status \(error)")
                }
            }
        
        tableView.reloadData()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoozy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
               
                do {
                    try self.realm?.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.item.append(newItem)
                    }
                } catch {
                    print("Error saving new item \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
  
       }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textField = alertTextField
            
         }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //MARK - Model Manipulation Methods
    
    
    
    //MARK: - loadItems
    
    func loadItems() {
        
        todoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    
    
    

}

//MARK: - Search bar methods

extension TodoListController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)



    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }



        }
    }

}

