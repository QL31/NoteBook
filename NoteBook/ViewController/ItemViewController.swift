//
//  ViewController.swift
//  NoteBook
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    var realm = try! Realm()
    
    var todoItem: Results<Item>?
    
    var selectedCategorie:Categorie? {
        didSet{
            loadItem()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "itemCell", for:indexPath)
        
        //        cell.textLabel?.text = todoItem?[indexPath.row].title
        
        if let item=todoItem?[indexPath.row]{
            
            cell.textLabel?.text=item.title
            
            cell.accessoryType=item.done ? .checkmark: .none
        }
        else{
            cell.textLabel?.text="No item added yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item=todoItem?[indexPath.row]{
            do{
                try realm.write{
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategorie{
                
                do{
                    try self.realm.write{
                        
                        let newItem=Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        
                    }
                }catch{
                    print("Error saving data \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField=field
            textField.placeholder="Add a new Item"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadItem(){
        
        todoItem=selectedCategorie?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
}

