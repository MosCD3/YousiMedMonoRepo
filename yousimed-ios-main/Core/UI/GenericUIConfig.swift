//
//  GenericUIConfigProtocol.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-06.
//
import UIKit
import FROnboarding

protocol GenericUIConfigProtocol {
    var mainThemeBackgroundColor: UIColor {get}
    var mainThemeForegroundColor: UIColor {get}
    var mainTextColor: UIColor {get}
    var mainSubtextColor: UIColor {get}
    var hairlineColor: UIColor {get}
    var colorGray0: UIColor {get}
    var colorGray3: UIColor {get}
    var colorGray9: UIColor {get}

    var statusBarStyle: UIStatusBarStyle {get}

    var regularSmallFont: UIFont {get}
    var regularMediumFont: UIFont {get}
    var regularLargeFont: UIFont {get}
    var mediumBoldFont: UIFont {get}

    var boldSmallFont: UIFont {get}
    var boldLargeFont: UIFont {get}
    var boldSuperLargeFont: UIFont {get}

    var italicMediumFont: UIFont {get}

    func regularFont(size: CGFloat) -> UIFont
    func boldFont(size: CGFloat) -> UIFont
    
    var onboardingUIConfig: OnboardingUIConfigProtocol {get}

    func configureUI()
}

protocol AppUIConfigurationProtocol: GenericUIConfigProtocol {
    //Add config specific to the App
}

class AppUIConfiguration: AppUIConfigurationProtocol {
    
    //Customize onboarding from here
    let onboardingUIConfig: OnboardingUIConfigProtocol = OnboardingUIConfig()
    
    static let shared: AppUIConfiguration = AppUIConfiguration()
    
    let mainThemeBackgroundColor: UIColor = .white
    let mainThemeForegroundColor: UIColor = UIColor(hexString: "#ff5a66")
    let mainTextColor: UIColor = UIColor(hexString: "#464646")
    let mainSubtextColor: UIColor = UIColor(hexString: "#999999") 
    let statusBarStyle: UIStatusBarStyle = .default
    let hairlineColor: UIColor = UIColor(hexString: "#d6d6d6")
    var colorGray0: UIColor = .black
    var colorGray3: UIColor = UIColor(hexString: "#333333")
    var colorGray9: UIColor = UIColor(hexString: "#f4f4f4")

//    let regularSmallFont = UIFont(name: "NotoSans", size: 12)!
//    let regularMediumFont = UIFont(name: "NotoSans", size: 14)!
//    let regularLargeFont = UIFont(name: "NotoSans", size: 18)!
//    let mediumBoldFont = UIFont(name: "NotoSans-Bold", size: 14)!
//    let boldLargeFont = UIFont(name: "NotoSans-Bold", size: 24)!
//    let boldSmallFont = UIFont(name: "NotoSans-Bold", size: 12)!
//    let boldSuperSmallFont = UIFont(name: "NotoSans-Bold", size: 10)!
//    let boldSuperLargeFont = UIFont(name: "NotoSans-Bold", size: 28)!
//    let italicMediumFont = UIFont(name: "TrebuchetMS-Italic", size: 14)!
    
    let regularSmallFont = UIFont.systemFont(ofSize: 12)
    let regularMediumFont = UIFont.systemFont(ofSize: 14)
    let regularLargeFont = UIFont.systemFont(ofSize: 18)
    let mediumBoldFont = UIFont.boldSystemFont(ofSize: 14)
    let boldLargeFont = UIFont.boldSystemFont(ofSize: 24)
    let boldSmallFont = UIFont.boldSystemFont(ofSize: 12)
    let boldSuperSmallFont = UIFont.boldSystemFont(ofSize: 10)
    let boldSuperLargeFont = UIFont.boldSystemFont(ofSize: 28)
    let italicMediumFont = UIFont.italicSystemFont(ofSize: 14)
    

    func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSans", size: size)!
    }

    func boldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSans-Bold", size: size)!
    }

    func configureUI() {
        
        //Do that in case of RTL
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        /*
        UITabBar.appearance().barTintColor = AppUIConfiguration.shared.mainThemeBackgroundColor
        UITabBar.appearance().tintColor = AppUIConfiguration.shared.mainThemeForegroundColor
        UITabBar.appearance().unselectedItemTintColor = AppUIConfiguration.shared.mainTextColor
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : AppUIConfiguration.shared.mainTextColor,
                                                          .font: AppUIConfiguration.shared.boldSuperSmallFont],
                                                         for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : AppUIConfiguration.shared.mainThemeForegroundColor,
                                                          .font: AppUIConfiguration.shared.boldSuperSmallFont],
                                                         for: .selected)

        UITabBar.appearance().backgroundImage = UIImage.colorForNavBar(AppUIConfiguration.shared.mainThemeBackgroundColor)
        UITabBar.appearance().shadowImage = UIImage.colorForNavBar(AppUIConfiguration.shared.hairlineColor)

        UINavigationBar.appearance().barTintColor = AppUIConfiguration.shared.mainThemeBackgroundColor
        UINavigationBar.appearance().tintColor = AppUIConfiguration.shared.mainThemeForegroundColor
         */
//
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: ATCUIConfiguration.shared.navigationBarTitleColor]
//        UINavigationBar.appearance().isTranslucent = false
//
//        UITabBar.appearance().tintColor = ATCUIConfiguration.shared.mainThemeColor
//        UITabBar.appearance().barTintColor = ATCUIConfiguration.shared.tabBarBarTintColor
//        if #available(iOS 10.0, *) {
//            UITabBar.appearance().unselectedItemTintColor = ATCUIConfiguration.shared.mainThemeColor
//        }
    }
}
