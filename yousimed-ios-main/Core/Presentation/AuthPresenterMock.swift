//
//  AuthPresenterMock.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-02-10.
//

import UIKit
import FRAuth

class AuthPresenterMock: AuthPresenterProtocol {
    
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
        let authcoordinator = FRAuthCoordinator(config: config)
        return  authcoordinator
    }
    
    func signIn(username: String, password: String, completion: @escaping GenericOPResult) {
        self.fetchLoggedInUser(id: "sfsdfsdfsdf")
        completion(false, nil, nil)
    }
    
    func fetchLoggedInUser(id: String) {
        self.state.activeUser = User(id: id, email: "whatever@example.com")
        //last step is save user id to keychain
        self.savedAppSettings.logUserIn(id: id)
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
        
        let predefinedEmail = "john.doe@example.com"
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
    
    private func onError(error:String) {
        router.alert(alert: AlertSettings(message: error,
                                               targetVc: UIViewController(),
                                               alertType: .normal,
                                               title: "Error!"))
    }
    
    
}
