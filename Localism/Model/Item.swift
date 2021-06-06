//
//  Item.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 05/06/21.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property : "items")
}
