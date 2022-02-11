//
//  FRAuthCoordinator.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-10.
//

import UIKit

public protocol FRAuthCoordinatorProtocol {
    var delegate:FRAuthCoordinatorActionDelegate? {get set}
    func start(uiConfig:FRAuthUIConfigProtocol, navController: UINavigationController)
    func navToRegister()
    func isNavbarHidden(_ value: Bool)
}

public protocol FRAuthCoordinatorActionDelegate: AnyObject {
    func signInWith(username:String, password: String, callback: @escaping AuthGenericOPResult)
    func createUser(username:String, password: String, callback: @escaping AuthGenericOPResult)
}

public struct FRAuthConfig {
    public var passwordCriteriaText: String?
    public var passwordCriteriaRegx: String?
    public var isRTL: Bool
    public var flowType: FRAuthFlowType = .normal
    public var predefinedUsername: String?
    public var isWaitingPasswordlessLogin: Bool = false
    
    public init(passwordCriteriaText: String?,
                passwordCriteriaRegx: String?,
                isRTL: Bool,
                flowType: FRAuthFlowType,
                predefinedUsername: String?,
                isWaitingPasswordlessLogin: Bool) {
        self.passwordCriteriaRegx = passwordCriteriaRegx
        self.passwordCriteriaRegx = passwordCriteriaRegx
        self.isRTL = isRTL
        self.flowType = flowType
        self.predefinedUsername = predefinedUsername
        self.isWaitingPasswordlessLogin = isWaitingPasswordlessLogin
        
    }
}

public class FRAuthCoordinator:FRAuthCoordinatorProtocol {
    
    public weak var delegate: FRAuthCoordinatorActionDelegate?
    var config: FRAuthConfig
    var uiConfig: FRAuthUIConfigProtocol?
    var navigationController: UINavigationController?
    
    public init(config:FRAuthConfig) {
        self.config = config
    }
    
    public func start(uiConfig: FRAuthUIConfigProtocol, navController: UINavigationController) {
        
        self.uiConfig = uiConfig
        self.navigationController = navController
        
        let presenter = LoginPresenter(config: config, router: self, uiConfig: uiConfig)
        presenter.delegate = self
        let vc = presenter.getViewController()
        navController.setViewControllers([vc], animated: true)
    }
    
    public func navToRegister() {
        
        guard let uiConfig = self.uiConfig else {
            return
        }
        
        let presenter = RegisterPresenter(config: config, coordinator: self, uiConfig: uiConfig)
        presenter.delegate = self
        let vc = presenter.getViewController()
        
       
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func isNavbarHidden(_ value: Bool){
        navigationController?.setNavigationBarHidden(value, animated: true)
    }
    
    //MARK: Helpers
    private func checkDelegate() {
        guard let _ = delegate else {
            print("Error[56] FRAuthCoordinator ->Delegate nil!")
            return
        }
    }
    
}


extension FRAuthCoordinator: LoginPresenterActionsDelegate {
    //Calls from ViewControllers
    func signIn(username: String, password: String, callback:@escaping AuthGenericOPResult) {
        checkDelegate()
        delegate?.signInWith(username: username, password: password, callback: callback)
    }
}


extension FRAuthCoordinator: RegisterPresenterActionDelegate {
    func register(username: String, password: String, callback: @escaping AuthGenericOPResult) {
        checkDelegate()
        delegate?.createUser(username: username, password: password, callback: callback)
    }
    
    
}
