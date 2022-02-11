//
//  AuthPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-16.
//

import UIKit
import FRAuth

protocol AuthPresenterProtocol {
    func getAuthView() -> FRAuthCoordinator
    func signIn(username: String, password: String, completion:  @escaping GenericOPResult)
    func fetchLoggedInUser(id: String)
    func register(username: String, password: String, completion:  @escaping GenericOPResult)
    func signOut(completion:  @escaping (String?) -> Void)
    func processPasswordlessAuthLink(link:String, completion: @escaping GenericOPResult)
}

class AuthPresenter: AuthPresenterProtocol {
  
    
   
    var dependency: AppDIContainerProtocol
    var interactor: AuthInteractorProtocol
    var interactorUser: UserDataInteractorProtocol
    var savedAppSettings: SavedAppSettingsProtocol
    var settings: AppSettingsProtocol
    var router: AppFlowCoordinatorProtocol
    var state: AppStateProtocol
    
    
    init(state:AppStateProtocol,
         diCont: AppDIContainerProtocol,
         router: AppFlowCoordinatorProtocol) {
        self.state = state
        self.dependency = diCont
        self.router = router
        self.interactor = dependency.makeAuthInteractor()
        self.interactorUser = dependency.makeUserDataInteractor()
        self.savedAppSettings = dependency.makeAppSettingsQueries()
        self.settings = dependency.settings
    }
    
    func getAuthView() -> FRAuthCoordinator {
        
        var config =  dependency.makeAuthConfig()
        if settings.authType == .passwordless, let predefinedEmail = savedAppSettings.isWaitingPasswordlessLink() {
            config.isWaitingPasswordlessLogin = true
            config.predefinedUsername = predefinedEmail
        }
        
        let authcoordinator = FRAuthCoordinator(config: config)
        return  authcoordinator
    }
    
    func signIn(username: String, password: String, completion: @escaping GenericOPResult) {
        interactor.signIn(username: username, password: password) { [weak self]
            isError,message, data in
            
            guard let self = self else {
                print("Seld disposed!")
                return
            }
            
            if isError {
                completion(true, message, nil)
                self.onError(error: message ?? "Unknown")
                return
            }
            
            
            if self.settings.authType == .normal {
                guard let user = data as? User else {
                    completion(true, "Error[30] User nill with no error!", nil)
                    self.onError(error: "Error[30] User nill with no error!")
                    return
                }
                
                //TODO: Load user profile
                self.fetchLoggedInUser(id: user.id)
                
            } else if self.settings.authType == .passwordless {
                self.savedAppSettings.sentPasswordlessLogin(forEmail: username)
                //Save email to prefs and wait app to launch using email link
            }
           
            
            completion(isError, message, data)
            
            
        }
    }
    
    
    func register(username: String, password: String, completion: @escaping GenericOPResult) {
        interactor.register(username: username, password: password) {
            isError, message, user in
            if isError {
                //Alert user on error
                self.onError(error: message ?? "Unknown")
                return
            }
            //TODO: Create user profile in DB
            guard let user = user as? User else {
                completion(true, "Error[83] User nill with no error!", nil)
                self.onError(error: "Error[83] User nill with no error!")
                return
            }
            
            completion(false, nil, user)
        }
    }
    
    func signOut(completion: @escaping (String?) -> Void) {
        savedAppSettings.logUserOut()
        completion(nil)
    }
    
    func processPasswordlessAuthLink(link: String, completion: @escaping GenericOPResult) {
        
        guard let predefinedEmail = savedAppSettings.isWaitingPasswordlessLink() else {
            print("Error[119] Saved email not found!")
            self.onError(error: "Cannot find email, please re-set login")
            completion(true,  "Cannot find email, please re-set login", nil)
            return
        }
        
        
        interactor.processPasswordlessAuth(withEmail: predefinedEmail, forLink: link) {
            isError, message, user in
            if isError {
                //Alert user on error
                self.onError(error: message ?? "Unknown")
                completion(true,  message ?? "Unknown", nil)
                return
            }
            
            guard let user = user as? User else {
                print("Error[30] User nill with no error!")
                self.onError(error: "Error[30] User nill with no error!")
                completion(true,  "Error[30] User nill with no error!", nil)
                return
            }
            

            self.fetchLoggedInUser(id: user.id)
            completion(false, nil, nil)
            
        }
    }
    
    func fetchLoggedInUser(id: String) {
        //User profile doesn't exist?, create profile
        self.interactorUser.createProfileIfNeeded(user: User(id: id)) {
            isError, message, data in
            if isError {
                self.onError(error: message ?? "Unknown")
                return
            }
            
            //User profile loaded? Refresh user model with full user details
            guard let loadedUser = data as? User else {
                self.onError(error: message ?? "Unknown")
                return
            }
            loadedUser.lastLogin = Utils.cuurentTimeStamp()
            self.interactorUser.updateLastLogin(forUser: loadedUser){
                isError, message, data in
                if isError {
                    self.onError(error: message ?? "Unknown")
                }
            }
            self.state.activeUser = loadedUser
            //last step is save user id to keychain
            self.savedAppSettings.logUserIn(id: id)
            
        }
    }
    
    
    private func onError(error:String) {
        router.alert(alert: AlertSettings(message: error,
                                               targetVc: UIViewController(),
                                               alertType: .normal,
                                               title: "Error!"))
    }
    
    
    
    
}
