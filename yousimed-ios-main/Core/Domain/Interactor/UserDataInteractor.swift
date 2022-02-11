//
//  UserDataInteractor.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-25.
//

import Foundation
import FirebaseFirestore

protocol UserDataInteractorProtocol {
    func createProfileIfNeeded(user:User, completion:  @escaping GenericOPResult)
    func fetchUser(userID: String, completion: @escaping GenericOPResult)
    func updateUser(user:User, completion: @escaping GenericOPResult)
    func updateLastLogin(forUser:User, completion: @escaping GenericOPResult)
}

class UserDataInteractor: UserDataInteractorProtocol {
    
    func createProfileIfNeeded(user: User, completion: @escaping GenericOPResult) {
        
        
        fetchUser(userID: user.id) { [weak self]
            isError, message, data in
            if isError && message == AppKeys.noUserFoundKey {
                print("Creating user profile..")
                let newUser = User(id: user.id,
                                   email: user.email ?? "",
                                   memberSince: Utils.cuurentTimeStamp())
                self?.updateUser(user: newUser, completion: completion)
                return
            }
            
            if isError {
                completion(isError, message, data)
                return
            }
            
            guard let fetchedUser = data as? User else {
                completion(true, "Error[32] User data cast failed!", nil)
                return
            }
            
            completion(false, nil, fetchedUser)
        }
    }
    
    func fetchUser(userID: String, completion:  @escaping GenericOPResult) {
        print("FirebaseWriter> Fetching user with id: \(userID)")
        
        let usersRef = Firestore.firestore().collection("users").whereField("id", isEqualTo: userID)
        usersRef.getDocuments { (querySnapshot, error) in
            if error != nil {
                
                print(" >Error fetching user:\(error?.localizedDescription ?? "--")")
                completion(true, error?.localizedDescription , nil)
                return
            }
            guard let querySnapshot = querySnapshot else {
                
                print(" >Error fetching user: querySnapshot nil")
                completion(true, " >Error fetching user: querySnapshot nil", nil)
                return
            }
            if let document = querySnapshot.documents.first {
                let data = document.data()
//                debugPrint("User fetched data is:", data)
                
                debugPrint("Hoo", data)
                let user = User(representation: data)
                
                print(" >User found!")
                completion(false, nil, user)
                
                
            } else {
                
                print( " >No user found!")
                completion(true,  AppKeys.noUserFoundKey, nil)
            }
        }
    }
    
    
    func updateUser(user:User, completion: @escaping GenericOPResult) {
        print("FBWriter> updateUser")
        let userRef = Firestore.firestore().collection("users").document(user.id)
        let userDictionary = user.representation()
        
        userRef.setData(userDictionary, merge: true) {
            err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(true, "Error writing document: \(err)", nil)
            } else {
                print("Document successfully written!")
                completion(false, nil, user)
            }
        }
    }
    
    
    func updateLastLogin(forUser:User, completion: @escaping GenericOPResult) {
        //adding those extra info to simplify query in firebase functions
        Firestore.firestore()
            .collection("users")
            .document("\(forUser.id)")
            .updateData([
                "lastLogin" :forUser.lastLogin,
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    completion(true, err.localizedDescription, nil)
                } else {
                    print("Successfully updated")
                    completion(false, nil, nil)
                }
            }
    }
}
