
import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems(with: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
    }
    
   //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done == false ? .none : .checkmark
        return cell
    }
    
    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do{
            try realm.write{
                itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            }
        }catch{
            print(error)
        }
        
        DispatchQueue.main.async{
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            print("works")
            if let text = alert.textFields?[0] {
                let item = Item()
                item.title = text.text!
                item.done = false
                do{
                    try self.realm.write{
                        self.selectedCategory?.items.append(item)
                    }
                }catch{
                    print(error)
                }
                self.itemArray.append(item)
                self.saveItems(item: item)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Write todo action"
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model manipulation methods
    func saveItems(item: Item) {
        do{
            try realm.write{
                realm.add(item)
            }
        } catch {
            print("error, \(error)")
        }
    }
    
    func loadItems(with filter: NSPredicate?) {
        let categoryPredicate = NSPredicate(format: "ANY parentCategory.name CONTAINS [C]%@", selectedCategory!.name)
        if let p = filter {
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, p])
            itemArray = realm.objects(Item.self).filter(predicate).sorted(by: { (item1, item2) -> Bool in
                return true
            })
        } else {
            itemArray = realm.objects(Item.self).filter(categoryPredicate).sorted(by: { (item1, item2) -> Bool in
                return true
            })
        }
    }
    
    override func deleteData(at indexPath: IndexPath) {
        do{
            try self.realm.write{
                self.selectedCategory?.items.remove(at: indexPath.row)
            }
            self.loadItems(with: nil)
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
  
}
//MARK: - SearchBar methods
extension ToDoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItems(with: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))
        tableView.reloadData()
      }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems(with: nil)
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
