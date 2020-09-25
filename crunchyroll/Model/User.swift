//
//  User.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

struct UserKeys {
    static let documentKey = "users"
    static let myLists = "myList"
}

class User: Codable {
    var myList: [String]
    
    init(myList: [String] = []) {
        self.myList = myList
    }
}

extension User {
    var documentDictionary: [String:Any] {
        let dictionary: [String:Any] = [
            UserKeys.myLists : myList
        ]
        return dictionary
    }
}
