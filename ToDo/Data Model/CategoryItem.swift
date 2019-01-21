//
//  CategoryItem.swift
//  ToDo
//
//  Created by Brian De Maio on 1/21/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
