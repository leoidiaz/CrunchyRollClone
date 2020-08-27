//
//  User.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

struct UserKeys {
    static let emailKey = "email"
}

class User {
    let email: String
    
    init(email: String, password: String) {
        self.email = email
    }
    
    init?(userDictionary: [String: Any]) {
        guard let email = userDictionary[UserKeys.emailKey] as? String else { fatalError("Can not find email address.") }
        self.email = email
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
            UserKeys.emailKey : email,
        ]
        return dictionary
    }
}
