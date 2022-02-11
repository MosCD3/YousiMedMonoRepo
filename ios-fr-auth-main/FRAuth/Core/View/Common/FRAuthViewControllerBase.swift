//
//  FRAuthViewControllerBase.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-15.
//

import UIKit
import Combine

class FRAuthViewControllerBase: UIViewController {
    
    private var presenter: GenericPresenter
    let config: FRAuthConfig
    let uiConfig: FRAuthUIConfigProtocol
    var viewAppeared: Bool = false
    
    enum GapSize {
        case small, medium, large
        
        var height: CGFloat  {
            switch self {
                
            case .small:
                return 20
            case .medium:
                return 40
            case .large:
                return 80
            }
        }
    }
    
    enum CaptionType {
        case small, medium, large
        
        var size: CGFloat  {
            switch self {
                
            case .small:
                return 12
            case .medium:
                return 14
            case .large:
                return 20
            }
        }
    }
    
    init(config:FRAuthConfig, presenter:GenericPresenter, uiConfig: FRAuthUIConfigProtocol) {
        self.config = config
        self.uiConfig = uiConfig
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = uiConfig.defaultBackgroundColor
        presenter.viewDidLoad()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewAppeared = true
    }
    private var cancellables: Set<AnyCancellable> = []
    
    private func bindViewModel() {
        presenter.isBusyPublisher.sink { [weak self] isBusy in
            self?.showHideSpinner(isActive: isBusy)
            
        }.store(in: &cancellables)
    }
    
    func makeInput(
        type: FieldType,
        placeholder: String,
        previousView: UIView,
        isPassword: Bool = false,
        withValue: String? = nil) -> FRATextField {
            
            let inputFld = FRATextField();
            inputFld.autocapitalizationType = .none
            inputFld.autocorrectionType = .no
            inputFld.translatesAutoresizingMaskIntoConstraints = false
            inputFld.placeholder = placeholder
            view.addSubview(inputFld)
            inputFld.leftAnchor.constraint(equalTo: view.leftAnchor, constant: FRAuthUIConfig.genericSidePadding).isActive = true
            inputFld.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -FRAuthUIConfig.genericSidePadding).isActive = true
            
            inputFld.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10).isActive = true
            
            inputFld.heightAnchor.constraint(equalToConstant: 50).isActive = true
            inputFld.backgroundColor = uiConfig.inputBackgroundColor
            
            if(isPassword) {
                inputFld.isSecureTextEntry = true
                inputFld.enablePasswordToggle(isRTL: config.isRTL)
            }
            
            inputFld.tag = type.tag
            inputFld.delegate = self
            if config.isRTL {
                inputFld.textAlignment = .right
            }
            inputFld.addDoneButtonOnKeyboard()
            inputFld.text = withValue
            return inputFld
        }
    
    func createButtons(title:String, previousView: UIView) -> UIButton{
        let button = FRButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(self.uiConfig.buttonTextColor, for: .normal)
        view.addSubview(button)
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: FRAuthUIConfig.genericSidePadding).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -FRAuthUIConfig.genericSidePadding).isActive = true
        button.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = self.uiConfig.buttonBackgroundColor
        return button
    }
    
    func createCaptionTxt(forText:String, withSize:CaptionType, previousView: UIView) -> UILabel {
        let text = UILabel()
        //info3Label.attributedText = "\(lt_msg)\(_updatedTxt)".attributedStringWithColor([String(count)], color: aptType.color)
        text.textColor = self.uiConfig.textColor
        text.text = forText
        //        text.attributedText = "Dont have account? Sign Up".attributedStringWithColor(["Sign Up"], color: self.uiConfig.linkColor)
        text.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(text)
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: FRAuthUIConfig.genericSidePadding).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -FRAuthUIConfig.genericSidePadding).isActive = true
        text.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 5).isActive = true
        //        let r = countLines(of: text, maxHeight: 140)
        let _width = view.bounds.width - FRAuthUIConfig.genericSidePadding * 2
        text.numberOfLines = countLines(of: text, forWidth: _width, maxHeight: 140)
        text.font = UIFont.systemFont(ofSize: withSize.size)
        if config.isRTL {
            text.textAlignment = .right
        }
        
        return text
    }
    
    
    func createGap(_ gapType: GapSize, previousView: UIView?) -> UIView {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_view)
        _view.heightAnchor.constraint(equalToConstant: gapType.height).isActive = true
        
        if let previousView = previousView {
            _view.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 0).isActive = true
            _view.leftAnchor.constraint(equalTo: previousView.leftAnchor).isActive = true
            _view.rightAnchor.constraint(equalTo: previousView.rightAnchor).isActive = true
        } else {
            _view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            _view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: FRAuthUIConfig.genericSidePadding).isActive = true
            _view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -FRAuthUIConfig.genericSidePadding).isActive = true
        }
        
        
        
        return _view
    }
    
    func styleInputField(fld: UITextField, isError:Bool){
        fld.layer.borderWidth = isError ? 2 : 0
        fld.layer.borderColor = isError ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
    
    //MARK: Helpers
    func countLines(of label: UILabel, forWidth:CGFloat, maxHeight: CGFloat) -> Int {
        // viewDidLayoutSubviews() in ViewController or layoutIfNeeded() in view subclass
        guard let labelText = label.text else {
            return 0
        }
        
        let rect = CGSize(width: forWidth, height: maxHeight)
        let labelSize = labelText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)
        
        let lines = Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
        return labelText.contains("\n") && lines == 1 ? lines + 1 : lines
    }
    
    func reAdjustLabel(label:UILabel) {
        
        let _width = view.bounds.width - FRAuthUIConfig.genericSidePadding * 2
        label.numberOfLines = countLines(of: label, forWidth: _width, maxHeight: 140)
    }
    
    
    func animateChanges() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: { [self] in
            //animations here
           
            self.view.layoutIfNeeded()
            
        }, completion: { (done) in
            //reset canned video view UI only after animation ends
            //
        })
    }
    
    func processInput(field: UITextField, textValue:String) {
        _ = validate(field: field, textValue: textValue)
    }
    
    func validate(field: UITextField, textValue:String) -> String?{
        
        let validator = Validator()
        var errorMessage: String?
        
        let tag = field.tag
        let value = textValue
        
       
        
        switch tag {
        case FieldType.reg_username.tag, FieldType.email.tag:
            if value == "" {
                styleInputField(fld: field, isError: false)
                errorMessage = "Please specify an email"
            } else {
                let error = validator.validate(text: value, with: [.validEmail])
                styleInputField(fld: field, isError: error != nil)
                errorMessage = error
            }
           
            break
        case FieldType.reg_password.tag:
            if value == "" {
                styleInputField(fld: field, isError: false)
                errorMessage = "Please specify a password"
            } else {
                
                if let regx = config.passwordCriteriaRegx {
                    let didMatch = validator.validateCustom(text: value, regEx: regx)
                    let isError = !didMatch
                    styleInputField(fld: field, isError: !didMatch)
                    if isError {
                        errorMessage = "Password criteria mismatch"
                    }
                }
            }
            
            
            break
        case FieldType.reg_passwordVerify.tag:
            ()
//            if value == "" {
//                styleInputField(fld: field, isError: false)
//                errorMessage = "Please confirm password"
//            } else {
//
//                if let pass = field.text {
//                    styleInputField(fld: field, isError: pass != value)
//                    if pass != value {
//                        errorMessage = "Password confirm mismatch!"
//                    }
//                }
//            }
            break
        case FieldType.password.tag:
            ()
            break
        default:
            print("Cannot find imp for tag:\(tag)")
            errorMessage = "Error[152] Contact Admin"
            break
        }
        
        return errorMessage
    }
    
    func showHideSpinner(isActive: Bool){
        if isActive {
            showSpinner()
        } else {
            hideSpinner()
        }
    }
    
}

extension FRAuthViewControllerBase: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        print("input with tag:\(textField.tag) new text:\(updatedText)")
        processInput(field: textField, textValue: updatedText)
        return true
    }
    
    
}

