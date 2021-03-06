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
        
    func createAuthUser(email: String, password: String, completion: @escaping (Result<Bool, CRError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
            guard result != nil else {
                return completion(.failure(.noData))
            }
            let newUser = User()
            db.collection(UserKeys.documentKey).document(email).setData(newUser.documentDictionary)
            self?.mylist = newUser.myList
            completion(.success(true))
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (Result<Bool, CRError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.thrownError(error)))
            }
            guard result != nil else {
                return completion(.failure(.noData))
            }
            completion(.success(true))
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
    
    func deleteUser(completion: @escaping (Result<Bool, CRError>) -> Void) {
        guard let user = Auth.auth().currentUser, let userEmail = user.email else { fatalError("Could not fetch current user")}
        deleteDocuments(user: user, userEmail: userEmail, completion: completion)
    }
    
    func deleteDocuments(user: FirebaseAuth.User, userEmail: String, completion: @escaping (Result<Bool, CRError>) -> Void){
        db.collection(UserKeys.documentKey).document(userEmail).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(.failure(.thrownError(err)))
            } else {
                user.delete { error in
                  if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(.failure(.thrownError(error)))
                  } else {
                    completion(.success(true))
                  }
                }
            }
        }
    }
}
