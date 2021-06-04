//
//  CategoryViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 03/06/21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    //MARK: - TableView Datasource Methoods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = dataArray[indexPath.row]
        cell.textLabel?.text = category.name
//        cell.accessoryType = item.done ? .checkmark : .none
                
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
                
                let newCategory = Category(context: self.context)
                newCategory.name = itemInput.text!
                
                self.dataArray.append(newCategory)
                
                self.saveData()
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
    
    func saveData(){
        
        do{
            try context.save()
            print("data saved successfuly!")
        }catch{
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            dataArray = try context.fetch(request)
        }catch{
            print("Error when fetching data : \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if the segue more than one
//        if(segue.identifier == "identifierOne"){
//          do code
//        }dst
        
        let destinationVC = segue.description as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = dataArray[indexPath.row]
        }
        
    }
    
    
}
