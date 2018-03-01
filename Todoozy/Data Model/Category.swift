//
//  Category.swift
//  Todoozy
//
//  Created by Jason Luehsenhop on 2/21/18.
//  Copyright © 2018 Jason Luehsenhop. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let item = List<Item>()
}
