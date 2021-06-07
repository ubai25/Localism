//
//  CategoryViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 03/06/21.
//

import UIKit
import RealmSwift

class CategoryViewController: ParentTableViewController{
    
    let realm = try! Realm()
    
    var categoryResults : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 50
        
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methoods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryResults?[indexPath.row].name
                
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryResults?.count ?? 1
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
    
    override func deleteItem(at indexPath: IndexPath){
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
}
