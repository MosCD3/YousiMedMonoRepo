//
//  AppointmentsPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-28.
//


import UIKit

protocol AppointmentsPresenterProtocol: Presentable {
    
}

protocol AppointmentsPresenterDelegate: AnyObject {
    
}

class AppointmentsPresenter: AppointmentsPresenterProtocol {
    
    var router: AppFlowCoordinatorProtocol
    let dependency: AppDIContainerProtocol
    weak var delegate: AppointmentsPresenterDelegate?
    
    init(router: AppFlowCoordinatorProtocol,
         dependency: AppDIContainerProtocol) {
        self.dependency = dependency
        self.router = router
    }
    
    
    func getViewController() -> UIViewController {
        let vc = AppointmentsViewController.create(dependency: dependency, with: self)
        
        return vc
    }
}
