
//  ViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 30/05/21.
//

import UIKit
import CoreData

class ToDoListViewController : UITableViewController{
    
    //Write the properties there
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadDataItems()
        }
    }

    //First Load
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //How many cell / row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    //Custom for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = dataArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
                
        return cell
    }
    
    //When List is pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //delete data
//        context.delete(dataArray[indexPath.row])
//        dataArray.remove(at: indexPath.row)
//
        dataArray[indexPath.row].done = !dataArray[indexPath.row].done
        
//        another way
//        let item = dataArray[indexPath.row]
//        item.setValue(false, forKey: "done")
        
        saveData()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //When add button preessed
    @IBAction func addButton(_ sender: Any) {
        
        var itemInput = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "kalo ada message gimana?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //When Submit new Item
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            
            if(itemInput.text! != ""){
                
                let newItem = Item(context: self.context)
                newItem.title = itemInput.text!
                newItem.done = false
                newItem.parentCat = self.selectedCategory
                
                self.dataArray.append(newItem)
                
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
    
    func loadDataItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let predicateCat = NSPredicate(format: "parentCat.name MATHES &@", selectedCategory!.name!)
        
        if let additionalPred = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCat, additionalPred])
        }else{
            request.predicate = predicateCat
        }
        
        do{
            dataArray = try context.fetch(request)
        }catch{
            print("Error when fetching data : \(error)")
        }
        
        tableView.reloadData()
    }
}

extension ToDoListViewController : UISearchBarDelegate{
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadDataItems(with: request)
//    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if(searchBar.text!.isEmpty){
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//
//    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty){
            loadDataItems()
            
//            searchBar.endEditing(true)
        }else{
            let request : NSFetchRequest<Item> = Item.fetchRequest()

            let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            loadDataItems(with: request, predicate: predicate)
        }
    }
}

