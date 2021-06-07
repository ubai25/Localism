//
//  Category.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 05/06/21.
//

import Foundation
import RealmSwift
import ChameleonFramework
class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var rowColor: String = UIColor.randomFlat().hexValue()
    
    let items = List<Item>()
}
