//
//  UserController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/27/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserController {
    
    static let shared = UserController()
    
    func createAuthUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard let result = result else {
                return completion(false)
            }
            print(result)
            completion(true)
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard let result = result else {
                return completion(false)
            }
            
            let userID = result.user.uid
            print(userID)
            completion(true)
        }
    }
}
