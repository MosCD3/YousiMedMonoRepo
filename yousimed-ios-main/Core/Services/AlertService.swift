//
//  AlertService.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-19.
//

import UIKit

enum AlertType {
    case normal, confirm, actionSheet, input
}

struct AlertSettings {
    //Mandatory
    var message: String
    var targetVc: UIViewController
    
    //Optional
    var alertType: AlertType = .normal
    var title: String = "Attention!"
    var dismissTitle: String = "Ok"
    var callback:  (()->Void)?
   
    //Extra for input alert
    var titleAction: String = "--"
    var inputCallback: ((String?)->Void)?
    
    //Extra for confirm
    var titleDismiss: String = "Cancel"
    var titleConfirm: String = "Ok"
    var confirmCallback: ((Bool)->Void)?
    
    //Extra for action sheet
    var actions:[(String, UIAlertAction.Style)]?
    var sheetCompletion: ((_ index: String) -> Void)?
}


protocol AlertServiceProtocol {
    func displayAlert(config: AlertSettings) -> Bool
}

class AlertService: AlertServiceProtocol {
    
    
    
    var ph_attention: String
    var ph_ok: String
    var ph_yes: String
    var ph_cancel: String
    var ph_save: String
    var ph_inputpl: String
    
    init() {
        ph_attention = "Attention"
        ph_ok = "Ok"
        ph_cancel = "Cancel"
        ph_save = "Save"
        ph_yes = "Yes"
        ph_inputpl = "Enter text"
        
    }
    
    func displayAlert(config: AlertSettings) -> Bool {
        switch config.alertType {
            
        case .normal:
            displayAlert(withVC: config.targetVc,
                         title: config.title,
                         message: config.message,
                         dismissTitle: config.dismissTitle,
                         callback: config.callback)
            
            
        case .confirm:
            
            displayConfirmAlert(withVC: config.targetVc,
                                title: config.title,
                                titleDismiss: config.titleDismiss,
                                titleConfirm: config.titleConfirm,
                                message: config.message,
                                callback: config.confirmCallback)
            
        case .actionSheet:
            
            guard let actions = config.actions, let completion = config.sheetCompletion else {
                print("Error[88] Actions/callbac nil for actionsheet, AlertSrv")
                return false
            }
            
            displayActionsheet(withVC: config.targetVc,
                               title: config.title,
                               message: config.message,
                               actions: actions,
                               completion: completion)
            
            
        case .input:
            
            displayInputAlert(withVC: config.targetVc,
                              title: config.title,
                              titleAction: config.titleAction,
                              message: config.message,
                              callback: config.inputCallback)
            
        }
        
        return true
    }
    
    //MARK: Private Methods
    private func displayAlert(withVC vc: UIViewController, title: String, message: String, dismissTitle: String, callback:  (()->Void)?  ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction (title: dismissTitle, style: .default) { (UIAlertAction) in
            callback?()
        }
        alert.addAction(dismissAction)
        vc.present(alert, animated: true, completion: nil)
    }

    
    private func displayInputAlert(withVC vc: UIViewController, title: String, titleAction: String, message: String, callback:  ((String?)->Void)? ) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let config: TextField.Config = { textField in
//            textField.becomeFirstResponder()
//            textField.textColor = .black
//            textField.placeholder = "Type something"
//            textField.left(image: image, color: .black)
//            textField.leftViewPadding = 12
//            textField.borderWidth = 1
//            textField.cornerRadius = 8
//            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
//            textField.backgroundColor = nil
//            textField.keyboardAppearance = .default
//            textField.keyboardType = .default
//            textField.isSecureTextEntry = true
//            textField.returnKeyType = .done
//            textField.action { textField in
//                // validation and so on
//            }
//        }
        

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = self.ph_inputpl
        }
        
        let saveAction = UIAlertAction(title: titleAction, style: UIAlertAction.Style.default, handler: {
            alert -> Void in
            if let firstTextField = alertController.textFields?[0] {
                callback?(firstTextField.text)
            }
            
        })
        let cancelAction = UIAlertAction(title: ph_cancel, style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            callback?(nil)
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func displayConfirmAlert(withVC vc: UIViewController, title: String, titleDismiss: String, titleConfirm: String, message: String, callback:  ((Bool)->Void)?  ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction (title: titleDismiss, style: .default) { (UIAlertAction) in
            callback?(false)
        }
        let confirmAction = UIAlertAction (title: titleConfirm, style: .default) { (UIAlertAction) in
            callback?(true)
        }
        alert.addAction(dismissAction)
        alert.addAction(confirmAction)
        vc.present(alert, animated: true, completion: nil)
    }

    
    
    private func displayActionsheet(withVC vc: UIViewController,  title: String, message: String? , actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: String) -> Void) {
        
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (_, (title, style)) in actions.enumerated() {
            
           
            //because ipad doesn't display cancel button so turn it to regular action
            var newStyle = style
            if UIDevice.current.userInterfaceIdiom == .pad && style == .cancel {
                newStyle = UIAlertAction.Style.default
            }
            let alertAction = UIAlertAction(title: title, style: newStyle) { (_) in
                completion(title)
            }
            alertViewController.addAction(alertAction)
        }

        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertViewController.popoverPresentationController {
                popoverController.sourceView = vc.view
                popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        
        vc.present(alertViewController, animated: true, completion: nil)
        
        
    }
}

