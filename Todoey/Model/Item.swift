//
//  Item.swift
//  Todoey
//
//  Created by Vlad on 7/21/20.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var  title : String = ""
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
