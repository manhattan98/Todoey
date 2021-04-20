//
//  CategorySelect.swift
//  Todoey
//
//  Created by Eremej Sumcenko on 29.03.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

extension ItemCategory {
    class func select(byName name: String) -> NSPredicate {
        NSPredicate(format: "name CONTAINS[cd] %@", argumentArray: [name])
    }
}
