//
//  FRRegisterViewController.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-15.
//

import UIKit

class FRRegisterViewController: FRAuthViewControllerBase {
    
    private var presenter:RegisterPresenterProtocol
    
    
    var userNameFld: FRATextField?
    var userNameFldCaptions: UILabel?
    var passwordFld: FRATextField?
    var passwordFldCaptions: UILabel?
    var passwordConfirmFld: FRATextField?
    var passwordConfirmFldCaptions: UILabel?
    
    
    
   init(config:FRAuthConfig,
        presenter:RegisterPresenterProtocol,
        uiConfig: FRAuthUIConfigProtocol) {
       
       self.presenter = presenter
       super.init(config: config,
                  presenter: presenter,
                  uiConfig: uiConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = uiConfig.defaultBackgroundColor
        title = "Sign Up"
        
        let gap1 = createGap(.large, previousView: nil)
        userNameFld = makeInput(type: .reg_username, placeholder: "Username", previousView: gap1, isPassword: false)
        
        userNameFldCaptions = createCaptionTxt(forText: "", withSize: .small, previousView: userNameFld!)
        styleCaptionLabel(label: userNameFldCaptions!)
        
        let gap = createGap(.small, previousView: self.userNameFldCaptions!)
        
        if let criteriaText = config.passwordCriteriaText {
            let txt = criteriaText
            let txtView = createCaptionTxt(forText: txt, withSize: .small, previousView: gap)
            
            self.passwordFld = makeInput(type: .reg_password, placeholder: "Password", previousView: txtView, isPassword: true)
        } else {
            self.passwordFld = makeInput(type: .reg_password, placeholder: "Password", previousView: gap, isPassword: true)
        }
       
        self.passwordConfirmFld = makeInput(type: .reg_passwordVerify, placeholder: "Password Confirm", previousView: self.passwordFld!, isPassword: true)
        
        
        passwordConfirmFldCaptions = createCaptionTxt(forText: "", withSize: .small, previousView: self.passwordConfirmFld!)
        styleCaptionLabel(label: passwordConfirmFldCaptions!)
        
        let regButton = createButtons(title: "Register", previousView: self.passwordConfirmFldCaptions!)
        regButton.addTarget(self, action: #selector(doRegister), for: .touchUpInside)
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        
    }
    
    func styleCaptionLabel(label: UILabel){
        label.textColor = .red
    }
    
   
    
    @objc func doRegister() {
        resetWarnings()
        
        guard let usernameFld = userNameFld,
              let username = usernameFld.text else {
            userNameFldCaptions?.text = "Please apecify an email"
            return
        }
        
        guard let passwordFld =  passwordFld ,
              let password =  passwordFld.text else {
            passwordConfirmFldCaptions?.text = "Please enter a password"
            return
        }
        
        
        if let usernameError = validate(field: usernameFld, textValue: username) {
            userNameFldCaptions?.text = usernameError
            return
        }
        
        if let passwordError = validate(field: passwordFld, textValue: password) {
            passwordConfirmFldCaptions?.text = passwordError
            return
        }
        
        guard let passwordConfirm =  passwordConfirmFld?.text else {
            passwordConfirmFldCaptions?.text = "Please confirm password"
            return
        }
        
        if passwordConfirm != password {
            passwordConfirmFldCaptions?.text = "Please confirm password"
            return
        }

        //Validate username
        presenter.register(username: username, password: password) {
            [weak self] error, message, data in
            guard let self = self else { return }
            
            //process result
        }
    }

    
    func resetWarnings() {
        userNameFldCaptions?.text = ""
        passwordConfirmFldCaptions?.text = ""
    }

}
