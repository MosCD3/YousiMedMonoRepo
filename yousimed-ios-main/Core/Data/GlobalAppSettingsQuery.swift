//
//  GlobalAppSettingsQuery.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-05.
//

import Foundation
protocol SavedAppSettingsProtocol {
    func isFirstRun() -> Bool
    func isOnboardingDone() -> Bool
    func doneOnboarding()
    func firstRun()
    func isLoggedIn() -> String?
    func logUserIn(id:String)
    func logUserOut()
    func sentPasswordlessLogin(forEmail:String)
    func isWaitingPasswordlessLink() -> String?
}

class GlobalAppSettingsQueryUserDefaults: SavedAppSettingsProtocol {
   
    var localStorage: PersistentStoreProtocol
    init(storage: PersistentStoreProtocol){
        localStorage =  storage
    }
    
    func isFirstRun() -> Bool {
        let saved = localStorage.getString(key: AppKeys.InitialRunStorageKey)
        return saved == nil
    }
    
    func isOnboardingDone() -> Bool {
        let saved = localStorage.getString(key: AppKeys.IsOnboardingDoneStorageKey)
        return saved != nil
    }
    
    func doneOnboarding() {
        localStorage.saveData(key: AppKeys.IsOnboardingDoneStorageKey, object: AppKeys.IsOnboardingDoneStorageKey)
    }
    
    func firstRun() {
        localStorage.saveData(key: AppKeys.InitialRunStorageKey, object: AppKeys.InitialRunStorageKey)
    }
    
    
    
    func isLoggedIn() -> String? {
        if let userId = localStorage.getString(key: AppKeys.UserIDKey) {
            return userId
        }
        print("No logged in user found!")
        return nil
    }
    
    func sentPasswordlessLogin(forEmail: String) {
        localStorage.saveData(key: AppKeys.PasswordlessAuthEmail, object: forEmail)
    }
    
    func isWaitingPasswordlessLink() -> String? {
        guard let isWaitingAuthEmail = localStorage.getString(key: AppKeys.PasswordlessAuthEmail) else {
            return nil
        }
        
        return isWaitingAuthEmail
    }
    
    //TODO: Move to Kechain secure storage
    func  logUserIn(id: String) {
        localStorage.saveData(key: AppKeys.UserIDKey, object: id)
    }
    
    func logUserOut() {
        localStorage.clearData(key: AppKeys.UserIDKey)
    }
}
