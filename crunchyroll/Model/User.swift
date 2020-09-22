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
    
    init?(userDictionary: [String: Any]) {
        guard let myLists = userDictionary[UserKeys.myLists] as? [String] else { fatalError("Can not find documents")}
        self.myList = myLists
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
