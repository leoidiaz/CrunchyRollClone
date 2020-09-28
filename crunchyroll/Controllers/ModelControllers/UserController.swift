//
//  UserController.swift
//  crunchyroll
//
//  Created by Leonardo Diaz on 8/27/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserController {
    let firestore = Firestore.firestore()
    static let shared = UserController()
    var mylist = [String]()
        
    func createAuthUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard result != nil else {
                return completion(false)
            }
            let newUser = User()
            db.collection(UserKeys.documentKey).document(email).setData(newUser.documentDictionary)
            self?.mylist = newUser.myList
            completion(true)
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            guard result != nil else {
                return completion(false)
            }
            completion(true)
        }
    }
    
    func fetchMyList(completion: @escaping (Result<Bool, CRError>) -> Void){
        guard let userEmail = Auth.auth().currentUser?.email else {fatalError("Could not fetch current user")}
        db.collection(UserKeys.documentKey).document(userEmail).addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let document = querySnapshot else {return completion(.failure(.noData))}
            guard let user = try? document.data(as: User.self) else { return completion(.failure(.noData))}
            self?.mylist = user.myList
            completion(.success(true))
        }
    }
    
    func addToList(animeID: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let myList = db.collection(UserKeys.documentKey).document(email)
        myList.updateData([UserKeys.myLists: FieldValue.arrayUnion([animeID])])
        mylist.append(animeID)
    }
    
    func removeFromList(animeID: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let myList = db.collection(UserKeys.documentKey).document(email)
        myList.updateData([UserKeys.myLists : FieldValue.arrayRemove([animeID])])
        if let index = mylist.firstIndex(of: animeID){mylist.remove(at: index)}
    }
}
