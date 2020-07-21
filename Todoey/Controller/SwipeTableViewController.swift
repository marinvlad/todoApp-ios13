//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Vlad on 7/21/20.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteData(at: indexPath)
           }
           // customize the action appearance
           deleteAction.image = UIImage(named: "delete-icon")
           
           return [deleteAction]
       }
    
    func deleteData(at indexPath: IndexPath){
        // Override in subclases
    }
}
