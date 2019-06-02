//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jay Phillips on 5/31/19.
//  Copyright © 2019 Jay Phillips. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        loadCategory()

        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            print("Saved")
            self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.categoryTableView.reloadData()
    }
    
    func loadCategory(for request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    
}

//MARK: - TableView Methods


extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {   
        performSegue(withIdentifier: "toItemViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ItemViewController
        
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
