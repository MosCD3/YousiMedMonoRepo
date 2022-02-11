//
//  FRLoginViewController.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-10.
//

import UIKit

enum LoginPageViewMode {
    case emailWithPassword
    case passwordlessLoginWithEmail
    case passwordlessLoginWithEmailWait
}

class FRLoginViewController: FRAuthViewControllerBase {
    

    
    private var presenter:LoginPresenterProtocol
    
   
    var userNameFld: FRATextField?
    var passwordFld: FRATextField?
    var loginButton: UIButton?
    var statusLabel: UILabel = UILabel()
    var viewMode: LoginPageViewMode? {
        didSet {
            switchViews()
        }
    }

    
   init(config:FRAuthConfig,
        presenter:LoginPresenterProtocol,
        uiConfig: FRAuthUIConfigProtocol) {
       
       self.presenter = presenter
       
       super.init(config: config,
                  presenter: presenter,
                  uiConfig: uiConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    func initUI() {
        //Add logo
        let logoView = addLogoIfAvailable()
        
        statusLabel = createCaptionTxt(forText: config.flowType.introText, withSize: .medium, previousView: createGap(.medium, previousView: logoView))
        
        self.userNameFld = makeInput(type: .email, placeholder: "Email", previousView: createGap(.small, previousView: statusLabel), withValue: config.predefinedUsername)
        
        //Adapt login to normal flow
        var prv:UIView = UIView()
        if config.flowType == .normal {
            
            //adding password field
            self.passwordFld = makeInput(type: .password, placeholder: "Password", previousView: self.userNameFld!, isPassword: true)
           
            let forgotPassFld = createCaptionTxt(forText: "Forgot password?", withSize: .small, previousView: self.passwordFld!)
            forgotPassFld.isUserInteractionEnabled = true
            forgotPassFld.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doForgotPassword)))
            if config.isRTL {
                forgotPassFld.textAlignment = .left
            } else {
                forgotPassFld.textAlignment = .right
            }
            prv = createGap(.small, previousView: forgotPassFld)
            
        } else if config.flowType == .passwordless {
            prv = self.userNameFld!
        }
        
       
        
        let loginBt = createButtons(title: config.flowType.signInTitle, previousView: prv)
        loginBt.addTarget(self, action: #selector(doSignIn), for: .touchUpInside)
        loginButton = loginBt
        
        if config.flowType != .passwordless {
            createSignUpTxt()
        }
        
        if config.flowType == .passwordless && config.isWaitingPasswordlessLogin {
            viewMode = .passwordlessLoginWithEmailWait
        }
        
    }
    
    func addLogoIfAvailable() -> UIView {
        let _view = UIImageView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(_view)
        _view.widthAnchor.constraint(equalToConstant: FRAuthUIConfig.iconImageSquareLength).isActive = true
        _view.heightAnchor.constraint(equalToConstant: FRAuthUIConfig.iconImageSquareLength).isActive = true
        _view.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        _view.topAnchor.constraint(equalTo: view.topAnchor, constant: FRAuthUIConfig.iconImageTopBearing).isActive = true
        if let image = self.uiConfig.logoImage {
            _view.image = image.withTintColor(self.uiConfig.logoImageTint)
            _view.contentMode = .scaleAspectFit
        }
       
        
        return _view
    }
    
    
    func createSignUpTxt() {
        let text = UILabel()
        //info3Label.attributedText = "\(lt_msg)\(_updatedTxt)".attributedStringWithColor([String(count)], color: aptType.color)
        text.textColor = self.uiConfig.textColor
        text.attributedText = "Dont have account? Sign Up".attributedStringWithColor(["Sign Up"], color: self.uiConfig.linkColor)
        text.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(text)
        text.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        text.font = UIFont.systemFont(ofSize: 12)
        
        text.heightAnchor.constraint(equalToConstant: 30).isActive = true
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        text.isUserInteractionEnabled = true
        text.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(doSignUp)))
    }
    
    func switchViews() {
        guard let viewMode = viewMode else {
            return
        }
        
        switch viewMode {
        case .emailWithPassword:
            ()
        case .passwordlessLoginWithEmail:
            
            self.statusLabel.text = config.flowType.introText
            reAdjustLabel(label: statusLabel)
            userNameFld?.setEnabled(true)
            userNameFld?.textColor = uiConfig.textColor
            loginButton?.setTitle(config.flowType.signInTitle, for: .normal)
            
        case .passwordlessLoginWithEmailWait:
            
            
            self.statusLabel.text = "Please follow the link in your inbox to login using the below email"
            reAdjustLabel(label: statusLabel)
            userNameFld?.isEnabled = false
            userNameFld?.setEnabled(false)
            loginButton?.setTitle("Re-send Link", for: .normal)

        }
        
        if viewAppeared {
            animateChanges()
        }
    }
    
    
    //MARK: Actions
    @objc func doSignIn(){
        
        
        if viewMode == .passwordlessLoginWithEmailWait {
            viewMode = .passwordlessLoginWithEmail
            return
        }
        
        guard
            let usernameFld = userNameFld,
            let username = usernameFld.text else {
                AuthAlertService.shared.displayAlert(config: AuthAlertSettings(message: "No email specified!", targetVc: self))
                return
        }
        
        if let error = validate(field: usernameFld, textValue: username) {
            AuthAlertService.shared.displayAlert(config: AuthAlertSettings(message: error, targetVc: self))
            return
        }
        var _pass:String = ""
        
        if config.flowType == .normal {
            if  let passwordFld = passwordFld,
                let password = passwordFld.text,
                let error = validate(field: passwordFld, textValue: password) {
                AuthAlertService.shared.displayAlert(config: AuthAlertSettings(message: error, targetVc: self))
            }
        } else {
            _pass = passwordFld?.text ?? ""
        }
        
        
        presenter.login(username: username, password: _pass) {
            [weak self] error, message, data in
            if error {
                print("Error logging in:\(message ?? "--")")
                return
            }
            
            self?.loginOperationSuccess()
        }
    }
    
    func loginOperationSuccess() {
        if config.flowType == .passwordless {
            viewMode = .passwordlessLoginWithEmailWait
        } else {
            //In case of normal login success, no need to to anything since the
            //main coordinator will switch to logged-in views
        }
    }
    
   
    
    @objc func doForgotPassword() {
        print("forgot pass")
    }
    
    @objc func doSignUp() {
        presenter.tappedCreateAccount()
    }

    

}
