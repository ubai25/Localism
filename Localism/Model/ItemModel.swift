//
//  ItemModel.swift
//  Localism
//
//  Created by Ahmad Ubaidillah on 01/06/21.
//
import Foundation

class ItemModel : Codable {
    
    var text : String = ""
    var done : Bool = false
    
    init(textIn : String){
        text = textIn
    }
    
}
