//
//  CategoryViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 03/06/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController{
    
    let realm = try! Realm()
    
    var categoryResults : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 50
        
        loadCategory()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryResults?.count ?? 1
    }
    
    //MARK: - TableView Datasource Methoods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryResults?[indexPath.row].name ?? "No Categories added yet"
        
        cell.delegate = self
                
        return cell
    }

    //MARK: - Add New Categories
    
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        
        var itemInput = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //When Submit new Item
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if(itemInput.text! != ""){
                
                let newCategory = Category()
                newCategory.name = itemInput.text!
                
                self.saveData(category: newCategory)
            }
        }
        
        alert.addTextField { uiTextField in
            uiTextField.placeholder = "Create new Item"
            itemInput = uiTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        categoryResults = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryResults?[indexPath.row]
        }
        
    }
    
    
}

extension CategoryViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            
            if let cat4delete = self.categoryResults?[indexPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(cat4delete)
                    }
                }catch{
                    print("Error saving context : \(error)")
                }
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage.init(named: "trash_Icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
