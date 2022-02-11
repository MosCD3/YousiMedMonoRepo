//
//  AuthInteractorPasswordless.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-21.
//

import FirebaseAuth

class AuthInteractorPasswordless: AuthInteractorProtocol {
    
    func signIn(username: String, password: String?, completion: @escaping  GenericOPResult) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://yousimed.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: username,
                                   actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
              completion(true, error.localizedDescription, nil)
              return
            }
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            completion(false, nil, nil)
            // ...
        }
        
    }
    
    
    //No implimentation here because this is a passwordless
    func register(username: String, password: String, completion: @escaping GenericOPResult) {
        ()
    }
    
    func processPasswordlessAuth(withEmail: String, forLink: String, completion: @escaping GenericOPResult) {
        
        print("Processing auth:\(withEmail) link:\(forLink)")
        Auth.auth().signIn(withEmail: withEmail, link: forLink) { result, error in
            if let error = error {
                completion(true, error.localizedDescription, nil)
                return
            }
            
            guard let _ = result?.user else {
                completion(true, "Error[59] User not found in auth!", nil)
                return
            }
            
            if (Auth.auth().currentUser?.isEmailVerified)! {
                completion(false, nil, AuthInteractor.makeUser(for: result))
            } else {
                completion(true,"Please verify your email address", nil)
            }
            
           
        }
        
    }
    
    
}
