//
//  ProfileTabPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-28.
//

import UIKit

protocol ProfileTabPresenterProtocol: Presentable {
    
}

protocol ProfileTabPresenterDelegate: AnyObject {
    
}

class ProfileTabPresenter: ProfileTabPresenterProtocol {
    
    var router: AppFlowCoordinatorProtocol
    let dependency: AppDIContainerProtocol
    weak var delegate: ProfileTabPresenterDelegate?
    
    init(router: AppFlowCoordinatorProtocol,
         dependency: AppDIContainerProtocol) {
        self.dependency = dependency
        self.router = router
    }
    
    
    func getViewController() -> UIViewController {
        let vc = ProfileTabViewController.create(dependency: dependency, with: self)
        
        return vc
    }
}
