//
//  TabNavItem.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-27.
//

import UIKit

public class TabNavItem {
    var viewController: UIViewController?
    var title: String?
    let image: UIImage?
    let selectedImage: UIImage?

    init(title: String?,
         image: UIImage?,
         selectedImage: UIImage? = nil,
         viewController: UIViewController? = nil){
        self.title = title
        self.viewController = viewController
        self.image = image
        self.selectedImage = selectedImage
    }

}
