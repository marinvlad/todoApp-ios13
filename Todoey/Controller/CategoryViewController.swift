//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vlad on 7/20/20.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData() 
    }
    let realm = try! Realm()
    //MARK: - Add new categories
    var categoryes = [Category]()
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let textData = alert.textFields?[0] {
                let categorie = Category()
                categorie.name = textData.text!
                self.categoryes.append(categorie)
                self.saveData(categorie: categorie)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter category name"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryes[indexPath.row].name
        return cell
    }
    
    //MARK: - Data manipulation methods
    
    func loadData(){
        categoryes = realm.objects(Category.self).sorted(by: { (categ1, categ2) -> Bool in
            if categ1.items.count > categ2.items.count {
                return true
            } else {
                return false
            }
        })
   
    }
    
    func saveData(categorie : Category) {
        do{
            try realm.write{
                realm.add(categorie)
            }
        }catch{
            print(error)
        }
    }
    
    override func deleteData(at indexPath: IndexPath) {
        do{
             try realm.write{
                realm.delete(categoryes[indexPath.row])
             }
            loadData()
            tableView.reloadData()
         }catch{
             print(error)
         }
    }
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destionationVC = segue.destination as! ToDoListViewController
            if let selectedRow = tableView.indexPathForSelectedRow {
                destionationVC.selectedCategory = categoryes[selectedRow.row]
            }
        }
    }
}
