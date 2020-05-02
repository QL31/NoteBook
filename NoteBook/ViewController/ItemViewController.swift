//
//  ViewController.swift
//  NoteBook
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemViewController: SwipeTableViewController {
    
    var realm = try! Realm()
    
    var todoItem: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategorie:Categorie? {
        didSet{
            loadItem()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategorie?.name
        guard let colorHex = selectedCategorie?.color else{fatalError()}
        
        updateNaviBar(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNaviBar(withHexCode: "28AAC0")
//        guard let originalColor = UIColor(hexString: "28AAC0") else {fatalError()}
//        navigationController?.navigationBar.barTintColor = originalColor
//        navigationController?.navigationBar.tintColor = FlatBlack()
//        navigationController?.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor: FlatWhite()]
        
    }
    
    func updateNaviBar(withHexCode colorHexCode : String){
        
        guard let navBar=navigationController?.navigationBar else {
            fatalError("navigation controler does not exist")
        }
        guard let navBarColor=UIColor(hexString: colorHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColor
        navBar.tintColor=ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell=tableView.dequeueReusableCell(withIdentifier: "itemCell", for:indexPath)
        
        //        cell.textLabel?.text = todoItem?[indexPath.row].title
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item=todoItem?[indexPath.row]{
            //            cell.textLabel?.text = item.title + "\(item.dateCreated)"
            //cell.backgroundColor = UIColor.randomFlat()
            cell.textLabel?.text = item.title
            cell.accessoryType=item.done ? .checkmark: .none
            if let color = UIColor(hexString: selectedCategorie!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItem!.count)){
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.backgroundColor = color
            }
            
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
                        newItem.dateCreated = Date()
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
    
    override func updateData(at indexPath: IndexPath) {
        
        if let item = todoItem?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(item)
                }
            }catch{
                print("Error deleting categorie data \(error)")
            }
        }
    }
    
}

extension ItemViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItem = todoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

