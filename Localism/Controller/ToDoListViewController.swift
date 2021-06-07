
//  ViewController.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 30/05/21.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController : ParentTableViewController{
    
    //Write the properties there
    var dataResults: Results<Item>?
    let realm = try! Realm()
    var cellColor = FlatSkyBlue().flatten().hexValue()
    
    @IBOutlet weak var searcBar: UISearchBar!
    
    var selectedCategory: Category?{
        didSet{
            loadDataItems()
        }
    }

    //First Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let color = selectedCategory?.rowColor{
            
            guard let navbar = navigationController?.navigationBar else {
                fatalError("NavBar Does not exist")
            }
            
            title = selectedCategory?.name
//            navbar.barTintColor = UIColor(hexString: color)
            navbar.backgroundColor = UIColor(hexString: color)
            navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)]
            navbar.tintColor = ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
            
            searcBar.barTintColor = UIColor(hexString: color)?.lighten(byPercentage: 0.5)
//            searcBar.tintColor = ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
//            searcBar.backgroundColor = UIColor(hexString: color)
        }
    }
    
    //How many cell / row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataResults?.count ?? 1
    }
    
    //Custom for every cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let data = dataResults?[indexPath.row]{
            cell.textLabel?.text = data.title
            cell.accessoryType = data.done ? .checkmark : .none
            
            if let color = UIColor.init(hexString: cellColor)?.darken(
                byPercentage: CGFloat(indexPath.row) / (CGFloat(dataResults!.count) * CGFloat(1.5))){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //When List is pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let data = dataResults?[indexPath.row]{
            do{
                try self.realm.write{
                    data.done = !data.done
                }
            }catch{
                print("Error saving context : \(error)")
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //When add button preessed
    @IBAction func addButton(_ sender: Any) {
        
        var itemInput = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "kalo ada message gimana?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //When Submit new Item
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            
            if(itemInput.text! != ""){
                if let category = self.selectedCategory{
                    do{
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = itemInput.text!
                            category.items.append(newItem)
                        }
                    }catch{
                        print("Error saving context : \(error)")
                    }
                    
                    self.tableView.reloadData()
                }else{
                    print("category null")
                }
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
    
    func loadDataItems(){
        dataResults = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    override func deleteItem(at indexPath: IndexPath){
        if let item4delete = self.dataResults?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(item4delete)
                }
            }catch{
                print("Error saving context : \(error)")
            }
        }
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
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if(searchBar.text!.isEmpty){
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
    
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//
//    }
//
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if(searchText.isEmpty){
            loadDataItems()

        }else{
            dataResults = dataResults?.filter("title CONTAINS[cd] %@", searchText)
                .sorted(byKeyPath: "date", ascending: true)
            
            tableView.reloadData()
        }
    }
}

