//
//  NoteBookTableViewController.swift
//  NoteBook
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import UIKit
import RealmSwift

class NoteBookTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Categorie>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategori()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categorieCell", for: indexPath)
        
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
