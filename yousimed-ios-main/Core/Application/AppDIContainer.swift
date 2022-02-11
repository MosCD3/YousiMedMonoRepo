//
//  AppDIContainer.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-04.
//

import UIKit
import FROnboarding
import FRAuth

protocol AppDIContainerProtocol {
    
    var uiConfig:AppUIConfigurationProtocol {get}
    var settings:AppSettingsProtocol {get}
    var router: AppFlowCoordinatorProtocol? {get set}
    func makeLocalStorageService() -> PersistentStoreProtocol
    func makeAlertService() -> AlertServiceProtocol
    func makeAppSettingsQueries() -> SavedAppSettingsProtocol
    func makeOnboardingFlow() -> OnboardingCoordinatorProtocol
    func makeOnboardingScreens() -> [OnboardingModel]
    func makeAuthInteractor() -> AuthInteractorProtocol
    func makeUserDataInteractor() -> UserDataInteractorProtocol
    func makeAuthPresenter() -> AuthPresenterProtocol?
    func makeAuthConfig() -> FRAuthConfig
    func makeHomeTabs() -> [TabNavItem]
}
class AppDIContainer: AppDIContainerProtocol {
   
    var router: AppFlowCoordinatorProtocol?
   
    lazy var storageUserDefaults:PersistentStoreProtocol  = PersistentStore()
    var uiConfig:AppUIConfigurationProtocol
    var settings:AppSettingsProtocol
    var state:AppStateProtocol
    
    init(state:AppStateProtocol,
         settings:AppSettingsProtocol,
         uiConfig: AppUIConfigurationProtocol){
        self.state = state
        self.uiConfig = uiConfig
        self.settings = settings
    }
    
    
    //MARK: Presenters/Managers
    //AuthPresenterProtocol
    func makeAuthPresenter() -> AuthPresenterProtocol? {
        guard let router = router else {
            print("Error[40] router undefined!")
            return nil
        }

//        return AuthPresenter(state: state, diCont: self, router: router)
        return AuthPresenterMock(state: state, diCont: self, router: router)
    }
    func makeHomeTabs() -> [TabNavItem] {
        return settings.navigationTabs
    }
    //MARK: Services
    func makeLocalStorageService() -> PersistentStoreProtocol {
        return PersistentStore()
    }
    
    func makeAlertService() -> AlertServiceProtocol {
        return AlertService()
    }
    
    
    //MARK: Global Queries
    func makeAppSettingsQueries() -> SavedAppSettingsProtocol {
        return GlobalAppSettingsQueryUserDefaults(storage: storageUserDefaults)
    }
    
    //MARK: Flow
    func makeOnboardingFlow() -> OnboardingCoordinatorProtocol {
        return OnboardingCoordinator()
    }
    
    //MARK: Interactors
    func makeAuthInteractor() -> AuthInteractorProtocol {
//        return settings.authType == .passwordless ? AuthInteractorPasswordless() : AuthInteractor()
        return  AuthInteractorMock()
    }
    
    func makeUserDataInteractor() -> UserDataInteractorProtocol {
        return UserDataInteractor()
    }
    
    
    //MARK: Config
    func makeAuthConfig() -> FRAuthConfig {
        return settings.authConfig
    }
    
    //Return screens for onboarding
    func makeOnboardingScreens() -> [OnboardingModel] {
        
        return  settings.onboardingScreens
    }
}
