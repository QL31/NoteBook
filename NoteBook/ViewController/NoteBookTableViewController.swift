//
//  NoteBookTableViewController.swift
//  NoteBook
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class NoteBookTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Categorie>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategori()
        tableView.rowHeight = 80.0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "categorieCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categorie added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath=tableView.indexPathForSelectedRow{
            destinationVC.selectedCategorie = categories?[indexPath.row]
        }
    }
    
    
    
    
    @IBAction func addCategorie(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert=UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "add", style:.default) { (action) in
            
            let newCategorie = Categorie()
            newCategorie.name=textField.text!
            
            self.save(categorie: newCategorie)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField=field
            textField.placeholder="Add a new categorie"
        }
        present(alert,animated: true, completion: nil)
        
    }
    
    
    func save(categorie:Categorie){
        do {
            try realm.write{
                realm.add(categorie)
            }
        }catch{
            print("Error adding category \(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategori(){
        
        categories=realm.objects(Categorie.self)
        tableView.reloadData()
    }
    
    
    
}
// MARK: swipe table view delegate

extension NoteBookTableViewController: SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("item delete")
            // handle action by updating model with deletion
            if let item = self.categories?[indexPath.row]{
                do{
                    try self.realm.write{
                        self.realm.delete(item)
                    }
                }catch{
                    print("Error deleting categorie data \(error)")
                }
                //tableView.reloadData()
                
            }
            
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-Icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
       // options.transitionStyle = .border
        return options
    }
}
