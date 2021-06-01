//
//  ViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 30/05/21.
//

import UIKit
//import SVProgressHUD

class ToDoListViewController : UITableViewController {
    
    var dummyArray = [ItemModel(textIn: "sholat shubuh"),ItemModel(textIn: "baca quran 1"), ItemModel(textIn: "olahraga"), ItemModel(textIn: "sarapan"), ItemModel(textIn: "mandi"), ItemModel(textIn: "sholat dhuha"), ItemModel(textIn: "start kerja"), ItemModel(textIn: "buka saham"),ItemModel(textIn: "sholat dzuhur"), ItemModel(textIn: "istirahat"), ItemModel(textIn: "makan siang"),ItemModel(textIn: "kerja lagi"), ItemModel(textIn: "sholat ashar"), ItemModel(textIn: "absen out"), ItemModel(textIn: "sholat maghrib"), ItemModel(textIn: "baca quran 2"), ItemModel(textIn: "Sholat Isya")]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoDatas") as? [ItemModel] {
            dummyArray = items
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = dummyArray[indexPath.row]
        cell.textLabel?.text = item.text
        cell.accessoryType = item.done ? .checkmark : .none
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dummyArray[indexPath.row].done = !dummyArray[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        var itemInput = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "kalo ada message gimana?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            
            if(itemInput.text! != ""){
                self.dummyArray.append(ItemModel(textIn: itemInput.text!))
                self.defaults.set(self.dummyArray, forKey: "ToDoDatas")
                self.tableView.reloadData()
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
}

