//
//  Category.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 05/06/21.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
