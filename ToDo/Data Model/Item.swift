//
//  Item.swift
//  ToDo
//
//  Created by Brian De Maio on 1/21/19.
//  Copyright © 2019 Brian De Maio. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: CategoryItem.self, property: "items")
}
