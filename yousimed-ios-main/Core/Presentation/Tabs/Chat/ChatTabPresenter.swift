//
//  ChatTabPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-28.
//

import UIKit

protocol ChatTabPresenterProtocol: Presentable {
    
}

protocol ChatTabPresenterDelegate: AnyObject {
    
}

class ChatTabPresenter: ChatTabPresenterProtocol {
    
    var router: AppFlowCoordinatorProtocol
    let dependency: AppDIContainerProtocol
    
    weak var delegate: ChatTabPresenterDelegate?
    
    init(router: AppFlowCoordinatorProtocol,
         dependency: AppDIContainerProtocol) {
        self.dependency = dependency
        self.router = router
    }
    
    
    func getViewController() -> UIViewController {
        let vc = ChatTabViewController.create(dependency: dependency, with: self)
        
        return vc
    }
}
