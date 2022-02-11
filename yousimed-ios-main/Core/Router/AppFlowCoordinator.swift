//
//  AppFlowCoordinator.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-04.
//

import UIKit
import FROnboarding
import FRAuth

enum AppDelegateActiona {
    case passwordlessAuthLink
}
protocol AppFlowCoordinatorProtocol {
    func start()
    func logOut()
    func alert(alert:AlertSettings)
    func actionFromAppDelegate(action:AppDelegateActiona, data:Any)
}

class AppFlowCoordinator: AppFlowCoordinatorProtocol {
   
    

    var window: UIWindow
    var navController: UINavigationController
    var uiConfig:AppUIConfigurationProtocol
    var settings:AppSettingsProtocol
    var dependency: AppDIContainerProtocol
    var appSettingsQuery: SavedAppSettingsProtocol
    lazy var authManager: AuthPresenterProtocol? = dependency.makeAuthPresenter()
    var alertService: AlertServiceProtocol
    var state: AppStateProtocol
    
    init(appWindow: UIWindow,
         state:AppStateProtocol,
         diCont: AppDIContainerProtocol){
        self.state = state
        dependency = diCont
        navController = UINavigationController()
        window = appWindow
        window.rootViewController = navController
        window.makeKeyAndVisible()
        uiConfig = dependency.uiConfig
        settings = dependency.settings
        appSettingsQuery = dependency.makeAppSettingsQueries()
        alertService = dependency.makeAlertService()
        
    }
    func start() {
        //Check if first app install, then run the onboarding
        navController.setNavigationBarHidden(true, animated: false)
        if appSettingsQuery.isOnboardingDone() {
            
            if let userId = appSettingsQuery.isLoggedIn() {
                startByLoggedIn(userId: userId)
            } else {
                startByAuth()
            }
            
        } else {
           startOnboarding()
        }
        
    }
    
    func logOut() {
        authManager?.signOut {
            error in
            guard error == nil else { return }
            self.startByAuth()
        }
    }
    
    func alert(alert: AlertSettings) {
        var props = alert
        
        
        guard let vc = navController.viewControllers.last else {
            print("Error[70]Coordinator cannot get top vc")
            return
        }
        
        props.targetVc = vc
        _ = alertService.displayAlert(config: props)
    }
    
    func actionFromAppDelegate(action: AppDelegateActiona, data: Any) {
        
        //If app opened using login link (Firebase auth)
        if action == .passwordlessAuthLink, let link = data as? String {
            authManager?.processPasswordlessAuthLink(link: link){
                isError, message, data in
                if !isError {
                    self.toLoggedInView()
                }
            }
        }
    }
    
    
    //MARK: Private methods
    private func startOnboarding(){
        
        let onboarding = OnboardingCoordinator()
        onboarding.delegate = self
        
        let onboardingController = onboarding.start(uiConfig: self.uiConfig.onboardingUIConfig,
                                                                  views: nil,
                                                                  models: dependency.makeOnboardingScreens())
            
        navController.setViewControllers([onboardingController], animated: true)
        
        
    }
    
    private func startByAuth(){
        
        guard let authManager = authManager else {
            print("Error[97] authManager nil")
            return
        }

        let authcoordinator = authManager.getAuthView()
        authcoordinator.delegate = self
        
        authcoordinator.start(uiConfig: FRAuthUIConfig(), navController: self.navController)
       
    }
    
    private func startByLoggedIn(userId: String) {
        print("please fetch user with id:\(userId)")
        authManager?.fetchLoggedInUser(id: userId)
        toLoggedInView()
    }
    
    fileprivate func toLoggedInView() {
        let tabsPresenter: TabsHostPresenterProtocol = TabsHostPresenter(router: self, dependency: dependency)
        let hostVC = tabsPresenter.getViewController()
        navController.setViewControllers([hostVC], animated: true)
    }
    
    /*
    func displayLoggedInViews(parentVc: HostViewController, tabController: UITabBarController) {
        let childVC: UITabBarController = tabController
        if tabController.view  != nil {
            UIView.transition(with: parentVc.view, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                parentVc.addChildViewControllerWithView(childVC)
            }, completion: {(finished) in
                //                if let user = self.user {
                //                    self.pushManager = ATCPushNotificationManager(user: user)
                //                    self.pushManager?.registerForPushNotifications()
                //                }
            })
        } else {
            print("tab nil")
        }
    }
     */
    
    
}


extension AppFlowCoordinator: OnboardingCoordinatorActionDelegate {
    func onboardingDone() {
        appSettingsQuery.doneOnboarding()
        startByAuth()
    }
}

//Actions from Auth Module
extension AppFlowCoordinator: FRAuthCoordinatorActionDelegate {
    func createUser(username: String, password: String, callback: @escaping AuthGenericOPResult) {
        self.authManager?.register(username: username, password: password) {
            error, message, data  in

            if error {
                callback(error, message, data)
                return
            }


            print("User created ..")
            print("Should create user profile")

            callback(error, message, data)
            
            
           
        }
    }
    
    func signInWith(username: String, password: String, callback: @escaping AuthGenericOPResult) {
        
        self.authManager?.signIn(username: username, password: password) {
            error, message, data in
            
            callback(error, message, data)
            
            if !error {
                if self.settings.authType == .normal {
                    self.toLoggedInView()
                }
            }
           
        }
       
    }
}
