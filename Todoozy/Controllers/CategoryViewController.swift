//
//  CategoryViewController.swift
//  Todoozy
//
//  Created by Jason Luehsenhop on 2/18/18.
//  Copyright © 2018 Jason Luehsenhop. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    
    let realm = try? Realm()
    
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.textColor = UIColor.red
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Found"
        
        return cell
        
    }
    
    //MARK - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm?.write {
                realm?.add(category)
            }
        } catch {
            print("Error saving new category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //LOAD CATEGORIES
    func loadCategories() {
        
        categories = realm?.objects(Category.self)
        

        tableView.reloadData()
        
    }
    
    
    //MARK - ADD NEW CATEGORIES
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoozy Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
                
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
}
