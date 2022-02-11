//
//  WelcomeViewModel.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-05.
//

import UIKit

protocol HomePresenterProtocol: Presentable {
    
}

protocol HomePresenterDelegate: AnyObject {
    
}

class HomePresenter: HomePresenterProtocol {
    
    var router: AppFlowCoordinatorProtocol
    let dependency: AppDIContainerProtocol
    weak var delegate: HomePresenterDelegate?
    
    init(router: AppFlowCoordinatorProtocol,
         dependency: AppDIContainerProtocol) {
        self.dependency = dependency
        self.router = router
    }
    
    
    func getViewController() -> UIViewController {
        let vc = HomeViewController.create(dependency: dependency, with: self)
        
        return vc
    }
}
