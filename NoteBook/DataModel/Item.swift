//
//  Item.swift
//  NoteBook
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool=false
    var perentCategorie = LinkingObjects(fromType: Categorie.self, property: "items")
}
