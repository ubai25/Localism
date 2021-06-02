//
//  ViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 30/05/21.
//

import UIKit
import CoreData
//import SVProgressHUD

class ToDoListViewController : UITableViewController {
    
    //Write the properties there
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataArray = [Item]()

    //First Load
    override func viewDidLoad() {
        super.viewDidLoad()
        print("file path : \(dataFilePath)")
        loadDataItems()
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
        
        dataArray[indexPath.row].done = !dataArray[indexPath.row].done
        
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
    
    func loadDataItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            dataArray = try context.fetch(request)
        }catch{
            print("Error when fetching data : \(error)")
        }
    }
}

