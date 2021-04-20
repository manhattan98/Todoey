//
//  Item.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 17.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject, Codable {
    /*private var _title: String = ""
    private var _done: Bool = false
    
    init(title: String) {
        self._title = title
    }
    
    var title: String {
        return _title
    }
    
    var isDone: Bool {
        get {
            return _done
        }
        set {
            _done = newValue
        }
    }*/
    
    func code() -> Data {
        let encoder = PropertyListEncoder()
        
        return try! encoder.encode(self)
    }
}
