//
//  Validator.swift
//  YousiMed
//
//  Created by Mostafa Gamal on 2022-01-17.
// https://www.advancedswift.com/regular-expressions/#email-regular-expression
//
import Foundation
import UIKit

class Validator {
    func validate(text: String, with rules: [Rule]) -> String? {
        return rules.compactMap({ $0.check(text) }).first
    }
    
    func validate(errorLabel: UILabel, text: String, with rules: [Rule]) {
        guard let message = validate(text: text, with: rules) else {
            errorLabel.isHidden = true
            return
        }
        
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    func validateCustom(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        _ = predicate.evaluate(with: text)
        return predicate.evaluate(with: text)
    }
}

struct Rule {
    // Return nil if matches, error message otherwise
    let check: (String) -> String?
    
    static let notEmpty = Rule(check: {
        return $0.isEmpty ? "Must not be empty" : nil
    })
    
    static let validEmail = Rule(check: {
        let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: $0) ? nil : "Must have valid email"
    })
    
    static let countryCode = Rule(check: {
        let regex = #"^\+\d+.*"#
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: $0) ? nil : "Must have prefix country code"
    })
}
