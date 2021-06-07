//
//  CategoryViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 03/06/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: ParentTableViewController{
    
    let realm = try! Realm()
    let color = FlatSkyBlue()
    
    var categoryResults : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        
        loadCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navbar = navigationController?.navigationBar else {
            fatalError("NavBar Does not exist")
        }
        
//        navbar.barTintColor = FlatMint()
        navbar.backgroundColor = color
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        navbar.tintColor = ContrastColorOf(color, returnFlat: true)
    }
    
    //MARK: - TableView Datasource Methoods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryResults?[indexPath.row]{
            cell.textLabel?.text = category.name
            
            if let color = UIColor.init(hexString: category.rowColor){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }
                
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
                newCategory.rowColor = UIColor.randomFlat().hexValue()
                
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryResults?[indexPath.row]
            destinationVC.cellColor = (categoryResults?[indexPath.row].rowColor)!
        }
        
    }
    
    override func deleteItem(at indexPath: IndexPath){
        if let cat4delete = self.categoryResults?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(cat4delete.items)
                    self.realm.delete(cat4delete)
                }
            }catch{
                print("Error saving context : \(error)")
            }
        }
    }
}
