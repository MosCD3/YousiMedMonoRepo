//
//  FRAuthUIConfig.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-10.
//

import UIKit

public  protocol FRAuthUIConfigProtocol {
    var defaultBackgroundColor: UIColor {get}
    var inputBackgroundColor: UIColor {get}
    var textColor: UIColor {get}
    var logoImage: UIImage? {get}
    var logoImageTint: UIColor {get}
    var buttonBackgroundColor: UIColor {get}
    var buttonTextColor: UIColor {get}
    var linkColor: UIColor {get}
}

public class FRAuthUIConfig: FRAuthUIConfigProtocol {
    
    //MARK: Satatic properties
    public static let iconImageSquareLength: CGFloat = 150
    public static let iconImageTopBearing: CGFloat = 160
    public static let genericSidePadding: CGFloat = 50
    
    public var defaultBackgroundColor: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .white
                case .dark: return .systemGray6
                @unknown default:
                    fatalError()
            }
        }
    }()
    
    public var inputBackgroundColor: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .systemGray5
            case .dark: return .systemGray5
                @unknown default:
                    fatalError()
            }
        }
    }()

    public var textColor: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .darkGray
                case .dark: return .white
                @unknown default:
                    fatalError()
            }
        }
    }()
    
    public var logoImage: UIImage? = UIImage(named: "apple-icon")
    
    public var logoImageTint: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .darkGray
                case .dark: return .white
                @unknown default:
                    fatalError()
            }
        }
    }()
    
    public var buttonBackgroundColor: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .darkGray
                case .dark: return .white
                @unknown default:
                    fatalError()
            }
        }
    }()
    
    public var buttonTextColor: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .white
                case .dark: return .black
                @unknown default:
                    fatalError()
            }
        }
    }()
    
    public var linkColor: UIColor =  {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
                case .unspecified, .light: return .systemBlue
                case .dark: return .orange
                @unknown default:
                    fatalError()
            }
        }
    }()
    
    public init() {}
}

