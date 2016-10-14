//
//  User.swift
//  musifinder
//
//  Created by Paul Beneteau on 07/10/2016.
//  Copyright © 2016 tastyapp. All rights reserved.
//

import UIKit

class User {
    private var _name: String = ""
    private var _id: String = ""
    
    var name: String {
        return _name
    }
    var id: String {
        return _id
    }
    
    init() {
        self._name = ""
        self._id = ""
    }
    
    init(name: String, id: String) {
        self._name = name
        self._id = id
    }
    
    
}
