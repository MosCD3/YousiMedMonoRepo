//
//  OnboardingUIConfig.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-05.
//

import UIKit

public  protocol OnboardingUIConfigProtocol {
    var defaultBackgroundColor: UIColor {get}
    var iconColor: UIColor {get}
    var textColor: UIColor {get}
    var indicatorColor: UIColor {get}
    var indicatorActiveColor: UIColor {get}
    var titleFont: UIFont {get}
    var descriptionFont: UIFont {get}
}

public class OnboardingUIConfig: OnboardingUIConfigProtocol {

    public var defaultBackgroundColor: UIColor = .systemGray6
    public var iconColor: UIColor = .white
    public var textColor: UIColor = .white
    public var indicatorColor: UIColor = .systemGray4
    public var indicatorActiveColor: UIColor = .systemGray
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 28)
    public var descriptionFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    public init() {}
}
