//
//  TabsHostPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-28.
//

import UIKit


protocol TabsHostPresenterDelegate: AnyObject {
    
}

protocol TabsHostPresenterProtocol: Presentable {
    
}

class TabsHostPresenter: TabsHostPresenterProtocol {
    
    var router: AppFlowCoordinatorProtocol
    let dependency: AppDIContainerProtocol
    weak var delegate: TabsHostPresenterDelegate?
    
    init(router: AppFlowCoordinatorProtocol,
         dependency: AppDIContainerProtocol) {
        self.dependency = dependency
        self.router = router
    }
    
    func getViewController() -> UIViewController {
        
        //Creating home tabs
        var navigationControllers: [UINavigationController] = []
        
        let tabs: [TabNavItem] = dependency.makeHomeTabs().map {
            
            var presenter: Presentable? = nil
            
            switch $0.title {
            case "Home":
                presenter = HomePresenter(router: router, dependency: dependency)
                break
            case "Appointments":
                presenter = AppointmentsPresenter(router: router, dependency: dependency)
                break
            case "Chat":
                presenter = ChatTabPresenter(router: router, dependency: dependency)
                break
            case "Profile":
                presenter = ProfileTabPresenter(router: router, dependency: dependency)
                break
            default:
                print("Error[62] One tab has no imp for title\(String(describing: $0.title))")
                break
            }
            
            
            if let presenter = presenter {
                let vc = presenter.getViewController()
                $0.viewController = vc
                navigationControllers.append(UINavigationController(rootViewController: vc))
            }
            
            return $0
        }
        
       
        
        let hostVC = LoggedInHostViewController(presenter: self, tabs: tabs)
        return hostVC
    }

}
