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
    static let emailKey = "email"
    static let myLists = "myList"
}

class User: Codable {
    var email: String
    var myLists: [String] = []
    
    init(email: String, password: String) {
        self.email = email
    }
    
    init?(userDictionary: [String: Any]) {
        guard let email = userDictionary[UserKeys.emailKey] as? String else { fatalError("Can not find email address.") }
        guard let myLists = userDictionary[UserKeys.myLists] as? [String] else { fatalError("Can not find documents")}
        self.email = email
        self.myLists = myLists
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }
}

extension User {
    var documentDictionary: [String:Any] {
        let dictionary: [String:Any] = [
            UserKeys.myLists : myLists
        ]
        return dictionary
    }
}
