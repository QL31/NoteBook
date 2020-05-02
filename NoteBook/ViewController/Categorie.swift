//
//  Categorie.swift
//  NoteBook
//
//  Created by li qinglian on 02/05/2020.
//  Copyright © 2020 li qinglian. All rights reserved.
//

import Foundation
import RealmSwift

class Categorie: Object{
    
    @objc dynamic var name : String=""
    
    let items = List<Item>()
}
    