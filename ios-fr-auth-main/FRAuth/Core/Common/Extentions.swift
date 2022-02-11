//
//  Extentions.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-10.
//

import Foundation
import UIKit

extension UIViewController {
    func showSpinner() {
        let sView = UIView(frame: self.view.bounds)
        sView.tag = 0xDEADBEEF
        sView.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = sView.center
        ai.startAnimating()
        sView.addSubview(ai)
        self.view.addSubview(sView)
    }
    
    func hideSpinner() {
        if let foundView = view.viewWithTag(0xDEADBEEF) {
            foundView.removeFromSuperview()
        }
    }
}


extension UITextField {
    
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "icons8-closed-eye-96"), for: .normal)
        }else{
            button.setImage(UIImage(named: "icons8-eye-96"), for: .normal)

        }
    }

    func enablePasswordToggle(isRTL: Bool){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: isRTL ? 0 : -16, bottom: 0, right: isRTL ? -16 : 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        if isRTL {
            self.leftView = button
            self.leftViewMode = .always
        } else {
            self.rightView = button
            self.rightViewMode = .always
        }
       
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
    
    func setEnabled(_ isEnabled: Bool) {
        let currentColor = textColor
        textColor = currentColor?.withAlphaComponent(isEnabled ? 1 : 0.5)
        self.isEnabled = isEnabled
    }
}


extension UITextField {
    
    func addDoneButtonOnKeyboard(title: String, target: Any, selector: Selector) {

            let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                                  y: 0.0,
                                                  width: UIScreen.main.bounds.size.width,
                                                  height: 44.0))//1
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
            let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
            toolBar.setItems([flexible, barButton], animated: false)//4
            self.inputAccessoryView = toolBar//5
        }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.defaultButtonAction))

        let items = [flexSpace, done]

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar

    }

    @objc func defaultButtonAction() {
        self.resignFirstResponder()
    }
}


extension String {
    //Allow coloring parts of a string
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
    
    func doHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
}

class FRATextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    
    convenience  init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


class FRButton: UIButton {
    
    convenience  init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
