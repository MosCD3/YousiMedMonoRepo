//
//  AppDelegate.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2021-11-23.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppFlowCoordinatorProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
//        FirebaseApp.configure()
        
        
        //Settings
        let appSettings = AppSettings()
        
        //UI
        let uiConfig = AppUIConfiguration()
        uiConfig.configureUI()
        
        //App state
        let appState = AppState()
        
        
        //Dependency generator
        let appDIContainer = AppDIContainer(state: appState,
                                            settings: appSettings,
                                            uiConfig: uiConfig)
        
        
        //Router
        window  = UIWindow(frame: UIScreen.main.bounds)
        let coordinator: AppFlowCoordinatorProtocol = AppFlowCoordinator(appWindow: window!,
                                                                         state: appState,
                                                                         diCont: appDIContainer)
        appDIContainer.router = coordinator
        
        //Flow start
        coordinator.start()
        self.coordinator = coordinator
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
    }
    
    func handlePasswordlessSignIn(withURL url:URL) -> Bool {
        
        
        let link = url.absoluteString
        print("App opened through link:\(link)")
        
        if link.contains("yousimed.page.link") {
            coordinator?.actionFromAppDelegate(action: .passwordlessAuthLink, data: link)
        } else {
            print("Warning!: No implimentation for that universal link!")
        }
        
        return true
    }
}

