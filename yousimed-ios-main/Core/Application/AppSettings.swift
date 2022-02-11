//
//  AppSettings.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-21.
//

import UIKit
import FRAuth
import FROnboarding

protocol AppSettingsProtocol {
    var authType: FRAuthFlowType {get}
    var authConfig: FRAuthConfig {get}
    var onboardingScreens: [OnboardingModel] {get}
    var navigationTabs: [TabNavItem] {get}
}

class AppSettings: AppSettingsProtocol {
    
    var onboardingScreens: [OnboardingModel] =  [
        OnboardingModel(title: "Test frist page", subtitle: "Take advantage of our amazing template to launch your iOS app today.", icon: "classifieds-logo"),
        OnboardingModel(title: "Map View", subtitle: "Visualize listings on the map to make your search easier.", icon: "apple-icon"),
        OnboardingModel(title: "Map View", subtitle: "Visualize listings on the map to make your search easier.", icon: "apple-icon"),
        OnboardingModel(title: "Map View", subtitle: "Visualize listings on the map to make your search easier.", icon: "apple-icon"),
        OnboardingModel(title: "Map View", subtitle: "Visualize listings on the map to make your search easier.", icon: "apple-icon"),
        ]
    
    
    var authConfig: FRAuthConfig  {
        get {
            
            //        let txt = """
            //            Password should have minimum
            //            - Minimum 8 characters long
            //            - One caps letter
            //            - One small letter
            //            """
                    
                    let txt2 = """
                        Password should have minimum
                        - Minimum 6 characters long
                        - One small letter
                        """
            //        let passwordPattern = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{6,}$"
                    let passwordPattern = "^(?=.*[a-z])(?=.*[0-9]).{6,}$"
            
            return FRAuthConfig(passwordCriteriaText: txt2,
                                passwordCriteriaRegx: passwordPattern,
                                isRTL: false,
                                flowType: authType,
                                predefinedUsername: nil,
                                isWaitingPasswordlessLogin: false)
        }
    }
    
    var authType: FRAuthFlowType = .normal
    
    var navigationTabs: [TabNavItem]  = [
        TabNavItem(title: "Home",
                   image: UIImage(named: "home_icon"),
                   selectedImage: UIImage(named: "home_icon_filled")),
        TabNavItem(title: "Appointments",
                   image: UIImage(named: "appointment_icon"),
                   selectedImage: UIImage(named: "appointment_icon_filled")),
        TabNavItem(title: "Chat",
                   image: UIImage(named: "chat_icon"),
                   selectedImage: UIImage(named: "chat_icon_filled")),
        TabNavItem(title: "Profile",
                   image: UIImage(named: "profile_icon"),
                   selectedImage: UIImage(named: "profile_icon_filled"))
    ]
  
}
