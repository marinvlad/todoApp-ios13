//
//  Category.swift
//  Todoey
//
//  Created by Vlad on 7/21/20.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    var items = List<Item>()
}
