//
//  ViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 30/05/21.
//

import UIKit
//import SVProgressHUD

class ToDoListViewController : UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var dataArray = [ItemModel]()

    //First Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataArray = dummyArray
        
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
        cell.textLabel?.text = item.text
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
                self.dataArray.append(ItemModel(textIn: itemInput.text!))
                
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(dataArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error Encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadDataItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                dataArray = try decoder.decode([ItemModel].self, from: data)
            } catch {
                print("Error decoding data : \(error)")
            }
        }
    }
}

