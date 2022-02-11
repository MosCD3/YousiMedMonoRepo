//
//  RegisterPresenter.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-17.
//

import Combine

protocol RegisterPresenterActionDelegate: AnyObject {
    func register(username:String, password: String, callback: @escaping AuthGenericOPResult)
}

class RegisterPresenter: RegisterPresenterProtocol {
    
    @Published var isBusy: Bool = false
    var isBusyPublisher: Published<Bool>.Publisher { $isBusy }
    
    private var coordinator:FRAuthCoordinatorProtocol
    private var config: FRAuthConfig
    private var uiConfig: FRAuthUIConfigProtocol
    
    weak var delegate:RegisterPresenterActionDelegate?
    
    init(config:FRAuthConfig,
         coordinator:FRAuthCoordinatorProtocol,
         uiConfig: FRAuthUIConfigProtocol) {
        self.config = config
        self.coordinator = coordinator
        self.uiConfig = uiConfig
    }
    
    func getViewController () -> FRRegisterViewController {
        
        let vc = FRRegisterViewController(config: config, presenter: self, uiConfig: uiConfig)
        return vc
        
    }
    
    func validate(for: FieldType, input: String) -> FRGenericOPResult {
        return FRGenericOPResult()
    }
    
    func register(username: String, password: String, callback: @escaping AuthGenericOPResult) {
        let validator = Validator()
        if let error = validator.validate(text: username, with: [.validEmail]) {
            callback(true,error, nil)
        }
        guard let delegate = delegate else {
            print("Error[50] delegate undefined")
            return
        }
        delegate.register(username: username, password: password) {
            error, message, data in
            callback(error,message,data)
        }
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        
    }
}

extension RegisterPresenter: LoginPresenterProtocol {
    func login(username: String, password: String, callback: @escaping AuthGenericOPResult) {
    
    }
    
    func tappedCreateAccount() {}
    
    func tappedForgotPass() {}
    
    
}


