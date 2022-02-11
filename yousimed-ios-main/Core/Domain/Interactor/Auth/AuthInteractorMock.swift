//
//  AuthInteractorMock.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-22.
//

import Foundation
class AuthInteractorMock: AuthInteractorProtocol {
    func processPasswordlessAuth(withEmail: String, forLink: String, completion: @escaping GenericOPResult) {
        completion(false, nil, User(id: "kgjsdfg", email: "john.doe@example.com"))
    }
    
    func signIn(username: String, password: String?, completion: @escaping GenericOPResult) {
       completion(false, nil, nil)
    }
    
    func register(username: String, password: String, completion: @escaping GenericOPResult) {
        ()
    }
}
