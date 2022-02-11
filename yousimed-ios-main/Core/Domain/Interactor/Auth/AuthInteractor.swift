//
//  AuthInteractor.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-16.
//
import FirebaseAuth


protocol AuthInteractorProtocol {
    func signIn(username: String, password: String?, completion:  @escaping GenericOPResult)
    func register(username: String, password: String, completion:  @escaping GenericOPResult)
    func processPasswordlessAuth(withEmail:String, forLink: String, completion: @escaping GenericOPResult)
}

class AuthInteractor: AuthInteractorProtocol {

    
    
    init(){
    }
    
    func signIn(username: String, password: String?, completion:  @escaping GenericOPResult) {
        
        guard let password = password else {
            completion(true, "Password undefined!", nil)
            return
        }
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error = error, let errCode = AuthErrorCode(rawValue: error._code) {
                switch errCode {
                case .userNotFound:
                    print("Login Failed, User not found!!:\(errCode)")
                case .wrongPassword:
                    print("Login Failed, wrong password!!:\(errCode)")
                default:
                    print("Login Failed!!:\(error.localizedDescription)")
                }
                completion(true, error.localizedDescription, nil)
            } else {
                completion(false, nil, AuthInteractor.makeUser(for: result))
            }
        }
    }
    
    func register(username: String, password: String, completion: @escaping GenericOPResult) {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            
            if let error = error {
                completion(true, error.localizedDescription, nil)
                return
            }
            
            guard let authedUser = authResult?.user else {
                completion(true, "Error[47] authResult?.user nil!", nil)
                return
            }
            completion(false, nil, User(id: authedUser.uid, email: username))
            
        }
    }
    
    func processPasswordlessAuth(withEmail:String, forLink: String, completion: @escaping GenericOPResult) {
        print("Error[64] No imp!")
    }
    
    public static func makeUser(for firebaseUser: AuthDataResult?) -> User? {
        guard
            let fUser = firebaseUser?.user,
            let email = fUser.email
        else {
            print("Error[39] User uid/email undefined")
            return nil
        }
        return User(id: fUser.uid, email: email)
    }
    
    
}


