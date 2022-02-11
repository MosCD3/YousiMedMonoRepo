//
//  LoginManager.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-17.
//
import Combine

protocol LoginPresenterActionsDelegate: AnyObject {
    func signIn(username:String, password: String, callback: @escaping AuthGenericOPResult)
}

class LoginPresenter: LoginPresenterProtocol {
    
    @Published var isBusy: Bool = false
    var isBusyPublisher: Published<Bool>.Publisher { $isBusy }
    
    private var router:FRAuthCoordinatorProtocol
    private var config: FRAuthConfig
    private var uiConfig: FRAuthUIConfigProtocol
    
    init(config:FRAuthConfig,
         router:FRAuthCoordinatorProtocol,
         uiConfig: FRAuthUIConfigProtocol) {
        self.config = config
        self.router = router
        self.uiConfig = uiConfig
    }
    
    weak var delegate: LoginPresenterActionsDelegate?
    
    func getViewController () -> FRLoginViewController {
        
        let vc = FRLoginViewController(config: config, presenter: self, uiConfig: uiConfig)
        
        return vc
        
    }
    
    func viewWillAppear() {
        router.isNavbarHidden(true)
    }
    
    func tappedCreateAccount() {
        router.navToRegister()
    }
    
    func tappedForgotPass() {
        
    }
    
    
    func login(username: String, password: String, callback: @escaping AuthGenericOPResult) {
        guard let delegate = delegate else {
            print("Error[51] AuthMod LoginPresenter delegate nil!")
            return
        }
        
        isBusy = true
        delegate.signIn(username: username, password: password) {
            [weak self] error, message, data in
            self?.isBusy = false
            callback(error, message, data)
        }
    }
    
    func viewDidLoad() {
        //Do something on page load
    }
    
    func validate(for: FieldType, input: String) -> FRGenericOPResult {
        return FRGenericOPResult()
    }
}


//extension LoginPresenter: RegisterPresenterProtocol {
//    func register(username: String, password: String, callback: @escaping (Bool, String?) -> Void){
//
//    }
//}
