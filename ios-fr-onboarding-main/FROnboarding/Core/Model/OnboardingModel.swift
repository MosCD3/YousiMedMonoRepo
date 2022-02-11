//
//  OnboardingModel.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-06.
//

public struct OnboardingModel {
    var title: String
    var subtitle: String
    var icon: String
    
    public init(title: String, subtitle: String, icon: String){
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}
